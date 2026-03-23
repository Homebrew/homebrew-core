class Nginx < Formula
  desc "HTTP(S) server and reverse proxy, and IMAP/POP3 proxy server"
  homepage "https://nginx.org/"
  # Use "mainline" releases only (odd minor version number), not "stable"
  # See https://www.nginx.com/blog/nginx-1-12-1-13-released/ for why
  url "https://nginx.org/download/nginx-1.29.6.tar.gz"
  sha256 "316f298cd9f061d6d0679696152710285b72f75d88eb1f7e323f40c5c52fe0d7"
  license "BSD-2-Clause"
  compatibility_version 2
  head "https://github.com/nginx/nginx.git", branch: "master"

  livecheck do
    url :homepage
    regex(%r{nginx[._-]v?(\d+(?:\.\d+)+)</a>\nmainline version}i)
  end

  bottle do
    sha256 arm64_tahoe:   "c1968131218256afd2c463348ad0a67d2912358c41a997f83d15abac665b513c"
    sha256 arm64_sequoia: "0384098ea93baab78bc68d9abb9711cb0da8a1c1da5262b626b51786226bbc9f"
    sha256 arm64_sonoma:  "779c49500d00718fa71fb15f26317b96d4e6f59a333a7aa79f606701f4af3e2d"
    sha256 sonoma:        "a867be0d1883346cc6142b579abcbf949f0770eb82fca5cc1f8d493e185afddc"
    sha256 arm64_linux:   "8a6ae2a98662e1c154737855d9d77d833d986bbf9ab372de434844d385c9bb3f"
    sha256 x86_64_linux:  "9bb12f36d9af98940cc174bbe18bc4d6593dc310d24a9d867c28809362d1c771"
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
      html.rename(dst)
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
