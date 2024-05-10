class Dillo < Formula
  desc "Fast and small graphical web browser"
  homepage "https://dillo-browser.github.io/"
  url "https://github.com/dillo-browser/dillo/releases/download/v3.1.0/dillo-3.1.0.tar.bz2"
  sha256 "f56766956d90dac0ccca31755917cba8a4014bcf43b3e36c7d86efe1d20f9d92"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "6b6ad17d3a8797bd5b1c8fede45201a498ce949ae0aa736614b0e8e0f65e6faf"
    sha256 arm64_ventura:  "bab53bbc438c2443d7f719d24efb696974b4173f05b48eeae96907d29cea911b"
    sha256 arm64_monterey: "0ec5d858b40c794c8bb15a5f03fd0fb77291dffd8a746d716eb4980608998f3f"
    sha256 sonoma:         "9193be742f33b7d2cb71777491ff014687fa0f2b8669584731722ada2fc0e891"
    sha256 ventura:        "6a879420943b29cd9c0fd67cc8b0b2ec1f0941947c2c89bb10b094d2ec40192f"
    sha256 monterey:       "a4ef74fa043c58267c4413225d4b2de5c22ab13520741a8cbe2ffd40b0f2ea86"
    sha256 x86_64_linux:   "0a24be77fa9c3812601d3acf746e178d1e411811aa345eb7f7c58091b73fa37b"
  end

  head do
    url "https://github.com/dillo-browser/dillo.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "fltk"
  depends_on "openssl@3"

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
    (testpath/"test.html").write <<~EOS
      <!DOCTYPE html>
      <html>
        <head>
            <title>BrewTest</title>
        </head>
        <body>
            <h1>test</h1>
        </body>
      </html>
    EOS

    # create bunch of dillo resource files
    (testpath/".dillo").mkpath
    (testpath/".dillo/dillorc").write ""
    (testpath/".dillo/keysrc").write ""
    (testpath/".dillo/domainrc").write ""
    (testpath/".dillo/hsts_preload").write ""

    begin
      PTY.spawn(bin/"dillo", test_file) do |_r, _w, pid|
        sleep 2
        Process.kill("TERM", pid)
      end
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end

    assert_match "DEFAULT DENY", (testpath/".dillo/cookiesrc").read

    assert_match "Dillo version #{version}", shell_output("#{bin}/dillo --version")
  end
end
