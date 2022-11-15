class Nginx < Formula
  desc "HTTP(S) server and reverse proxy, and IMAP/POP3 proxy server"
  homepage "https://nginx.org/"
  # Use "mainline" releases only (odd minor version number), not "stable"
  # See https://www.nginx.com/blog/nginx-1-12-1-13-released/ for why
  url "https://nginx.org/download/nginx-1.23.2.tar.gz"
  sha256 "a80cc272d3d72aaee70aa8b517b4862a635c0256790434dbfc4d618a999b0b46"
  license "BSD-2-Clause"
  head "https://hg.nginx.org/nginx/", using: :hg

  livecheck do
    url :homepage
    regex(%r{nginx[._-]v?(\d+(?:\.\d+)+)</a>\nmainline version}i)
  end

  bottle do
    sha256 arm64_ventura:  "dd146745e55a270c49ccbe7db443c597f918ef6b6713cbb584d44d101b9e9a82"
    sha256 arm64_monterey: "aa21d5f57a4ded0df4979cde9b14f150a9206d7fb9a7e0482d6725061ab6bf84"
    sha256 arm64_big_sur:  "739c2671d45664a07b635e2427b5bc22ffa55efa3a3c77900559a714818f869f"
    sha256 ventura:        "f7a6f9e03f16559ebcb0e145b5342153a5eeda3cb4c8e4741b3a1927cdd3a872"
    sha256 monterey:       "83c85727bbcfff076950edf8d7f68609cf7e2917d7b6519a359405d68b401f78"
    sha256 big_sur:        "a68cd16a00e830fce596ebd2e6e36f4ca4756b5199e98c5e993f6b3bb53374eb"
    sha256 catalina:       "3ec26f40ea33cf15e1cf02bbc1cb0961e8b56f425b17e43dd363d29f65a88df4"
    sha256 x86_64_linux:   "c222ac53d58d52621da7a4a5898aad01b3bb1a71afc5669b807c9692bf0cd49d"
  end

  depends_on "openssl@1.1"
  depends_on "pcre2"

  uses_from_macos "xz" => :build
  uses_from_macos "libxcrypt"

  def install
    # keep clean copy of source for compiling dynamic modules e.g. passenger
    (pkgshare/"src").mkpath
    system "tar", "-cJf", (pkgshare/"src/src.tar.xz"), "."

    # Changes default port to 8080
    inreplace "conf/nginx.conf" do |s|
      s.gsub! "listen       80;", "listen       8080;"
      s.gsub! "    #}\n\n}", "    #}\n    include servers/*;\n}"
    end

    openssl = Formula["openssl@1.1"]
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
      html.rmtree
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
    if OS.linux?
      run [opt_bin/"nginx", "-g", "'daemon off;'"]
    else
      run [opt_bin/"nginx", "-g", "daemon off;"]
    end
    keep_alive false
    working_dir HOMEBREW_PREFIX
  end

  test do
    (testpath/"nginx.conf").write <<~EOS
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
    EOS
    system bin/"nginx", "-t", "-c", testpath/"nginx.conf"
  end
end
