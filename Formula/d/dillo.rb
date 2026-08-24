class Dillo < Formula
  desc "Fast and small graphical web browser"
  homepage "https://dillo-browser.github.io/"
  url "https://github.com/dillo-browser/dillo/releases/download/v3.2.0/dillo-3.2.0.tar.bz2"
  sha256 "1066ed42ea7fe0ce19e79becd029c651c15689922de8408e13e70bb5701931bf"
  license "GPL-3.0-or-later"
  revision 1

  bottle do
    sha256 arm64_tahoe:   "da77692abb96f86d4d0427308f403fbcf16d065976fa32f5fb98a60ac93c159a"
    sha256 arm64_sequoia: "dfa302f5f967a9b01d66755ab4b1e37fcfb8095ce68c2cadfeb66c43f11f031f"
    sha256 arm64_sonoma:  "85d85b5e3c449de29a6d2ad5f607ab17545fff90f3a21f88a4b741c5e76089c1"
    sha256 sonoma:        "115efce250911169652cabaf6917acecd236e80b648dd7dd3a27cd8df5f28181"
    sha256 arm64_linux:   "8702a43940327df2fc982348866612cd9f0085c341032a5688d08edf1aac011b"
    sha256 x86_64_linux:  "638583a861928687adc34e6b7293d7a27dc5b94f02bf2b94845a68a7f85bdf00"
  end

  head do
    url "https://github.com/dillo-browser/dillo.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  # TODO: Switch to unversioned `fltk` when possible.
  # https://github.com/dillo-browser/dillo/issues/246
  depends_on "fltk@1.3"
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "openssl@4"

  on_linux do
    depends_on "libx11"
    depends_on "zlib-ng-compat"
  end

  def install
    if build.head?
      ENV["NOCONFIGURE"] = "1"
      system "./autogen.sh"
    end

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    test_file = testpath/"test.html"
    (testpath/"test.html").write <<~HTML
      <!DOCTYPE html>
      <html>
        <head>
            <title>BrewTest</title>
        </head>
        <body>
            <h1>test</h1>
        </body>
      </html>
    HTML

    # create bunch of dillo resource files
    (testpath/".dillo").mkpath
    (testpath/".dillo/dillorc").write ""
    (testpath/".dillo/keysrc").write ""
    (testpath/".dillo/domainrc").write ""
    (testpath/".dillo/hsts_preload").write ""

    begin
      PTY.spawn(bin/"dillo", test_file) do |_r, _w, pid|
        sleep 15
        Process.kill("TERM", pid)
      end
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end

    assert_match "DEFAULT DENY", (testpath/".dillo/cookiesrc").read

    assert_match version.to_s, shell_output("#{bin}/dillo --version")
  end
end
