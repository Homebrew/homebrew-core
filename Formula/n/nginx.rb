class Nginx < Formula
  desc "HTTP(S) server and reverse proxy, and IMAP/POP3 proxy server"
  homepage "https://nginx.org/"
  # Use "mainline" releases only (odd minor version number), not "stable"
  # See https://www.nginx.com/blog/nginx-1-12-1-13-released/ for why
  url "https://nginx.org/download/nginx-1.31.3.tar.gz"
  sha256 "a7657c50811c2d92d9895395e8b873ef60398142c4db21eb647811c38f6dd525"
  license "BSD-2-Clause"
  compatibility_version 8
  head "https://github.com/nginx/nginx.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{nginx[._-]v?(\d+(?:\.\d+)+)</a>\nmainline version}i)
  end

  bottle do
    sha256 arm64_tahoe:   "e0773ed80b56bf9c51c0022faa28dee9ebc329e1637e4d620edf5c54dc621928"
    sha256 arm64_sequoia: "56d837f739f2f8f7bb3184f25ff9cc5d2bb77e9d0bca03606287871a943a843e"
    sha256 arm64_sonoma:  "7fde7eda4f038ef3001e97f1c4937c36bb3091c299787d1358703c84bdb824d8"
    sha256 sonoma:        "5eba9b21bfd0bab7ab89341b5b85a8ca0051d3d3b50639ffc45f4aac18061e57"
    sha256 arm64_linux:   "c130638817fe45b3986dbdce98fa991faa81d560a939091a9e6ea337606d07b7"
    sha256 x86_64_linux:  "32e55bde0724ffac242a88765d9436c553abcd43ca1499bb6a4d2d24fef620a5"
  end

  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "xz" => :build
  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # keep clean copy of source for compiling dynamic modules e.g. passenger
    (pkgshare/"src").mkpath
    system "tar", "-cJf", (pkgshare/"src/src.tar.xz"), "."

    # Changes default port to 8080
    inreplace "conf/nginx.conf" do |s|
      s.gsub! "listen       80;", "listen       8080;"
      s.gsub! "    #}\n\n}", "    #}\n    include servers/*;\n}"
    end

    openssl = Formula["openssl@3"]
    pcre = Formula["pcre2"]

    cc_opt = "-I#{pcre.opt_include} -I#{openssl.opt_include}"
    ld_opt = "-L#{pcre.opt_lib} -L#{openssl.opt_lib}"

    args = %W[
      --prefix=#{prefix}
      --sbin-path=#{bin}/nginx
      --with-cc-opt=#{cc_opt}
      --with-ld-opt=#{ld_opt}
      --conf-path=#{etc}/nginx/nginx.conf
      --pid-path=#{var}/run/nginx.pid
      --lock-path=#{var}/run/nginx.lock
      --http-client-body-temp-path=#{var}/run/nginx/client_body_temp
      --http-proxy-temp-path=#{var}/run/nginx/proxy_temp
      --http-fastcgi-temp-path=#{var}/run/nginx/fastcgi_temp
      --http-uwsgi-temp-path=#{var}/run/nginx/uwsgi_temp
      --http-scgi-temp-path=#{var}/run/nginx/scgi_temp
      --http-log-path=#{var}/log/nginx/access.log
      --error-log-path=#{var}/log/nginx/error.log
      --with-compat
      --with-debug
      --with-http_addition_module
      --with-http_auth_request_module
      --with-http_dav_module
      --with-http_degradation_module
      --with-http_flv_module
      --with-http_gunzip_module
      --with-http_gzip_static_module
      --with-http_mp4_module
      --with-http_random_index_module
      --with-http_realip_module
      --with-http_secure_link_module
      --with-http_slice_module
      --with-http_ssl_module
      --with-http_stub_status_module
      --with-http_sub_module
      --with-http_v2_module
      --with-http_v3_module
      --with-ipv6
      --with-mail
      --with-mail_ssl_module
      --with-pcre
      --with-pcre-jit
      --with-stream
      --with-stream_realip_module
      --with-stream_ssl_module
      --with-stream_ssl_preread_module
    ]

    (pkgshare/"src/configure_args.txt").write args.join("\n")

    if build.head?
      system "./auto/configure", *args
    else
      system "./configure", *args
    end

    system "make", "install"
    if build.head?
      man8.install "docs/man/nginx.8"
    else
      man8.install "man/nginx.8"
    end
  end

  def post_install
    (etc/"nginx/servers").mkpath
    (var/"run/nginx").mkpath

    # nginx's docroot is #{prefix}/html, this isn't useful, so we symlink it
    # to #{HOMEBREW_PREFIX}/var/www. The reason we symlink instead of patching
    # is so the user can redirect it easily to something else if they choose.
    html = prefix/"html"
    dst = var/"www"

    if dst.exist?
      rm_r(html)
      dst.mkpath
    else
      dst.dirname.mkpath
      mv(html, dst)
    end

    prefix.install_symlink dst => "html"

    # for most of this formula's life the binary has been placed in sbin
    # and Homebrew used to suggest the user copy the plist for nginx to their
    # ~/Library/LaunchAgents directory. So we need to have a symlink there
    # for such cases
    sbin.install_symlink bin/"nginx" if rack.subdirs.any? { |d| d.join("sbin").directory? }
  end

  def caveats
    <<~EOS
      Docroot is: #{var}/www

      The default port has been set in #{etc}/nginx/nginx.conf to 8080 so that
      nginx can run without sudo.

      nginx will load all files in #{etc}/nginx/servers/.
    EOS
  end

  service do
    run [opt_bin/"nginx", "-g", "daemon off;"]
    keep_alive false
    working_dir HOMEBREW_PREFIX
  end

  test do
    (testpath/"nginx.conf").write <<~NGINX
      worker_processes 4;
      error_log #{testpath}/error.log;
      pid #{testpath}/nginx.pid;

      events {
        worker_connections 1024;
      }

      http {
        client_body_temp_path #{testpath}/client_body_temp;
        fastcgi_temp_path #{testpath}/fastcgi_temp;
        proxy_temp_path #{testpath}/proxy_temp;
        scgi_temp_path #{testpath}/scgi_temp;
        uwsgi_temp_path #{testpath}/uwsgi_temp;

        server {
          listen 8080;
          root #{testpath};
          access_log #{testpath}/access.log;
          error_log #{testpath}/error.log;
        }
      }
    NGINX
    system bin/"nginx", "-t", "-c", testpath/"nginx.conf"
  end
end
