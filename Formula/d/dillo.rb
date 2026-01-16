class Dillo < Formula
  desc "Fast and small graphical web browser"
  homepage "https://dillo-browser.github.io/"
  url "https://github.com/dillo-browser/dillo/releases/download/v3.2.0/dillo-3.2.0.tar.bz2"
  sha256 "1066ed42ea7fe0ce19e79becd029c651c15689922de8408e13e70bb5701931bf"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_tahoe:   "fd56c3ac780ea1c1d420546b8691773d85b8259308dafa3c3227921f423a29da"
    sha256 arm64_sequoia: "0207d59785da8978150221c348a04269db1e6af49b16cea243aeaeb2d874592d"
    sha256 arm64_sonoma:  "28b93f6b93b643299e98f8f9b543b55784ce83e16e624d460453b2741b4faa61"
    sha256 arm64_ventura: "91e47bdc6957706b451ad79446f0807b46f7ad3bd52ed9e4b3e7fbf7f68e7656"
    sha256 sonoma:        "eb64b7f51d5fd459bf3dc5ceffebc8f44a8cccf2e5288fd8bd2bc00e076c7d7a"
    sha256 ventura:       "d67a1834f6bdb695b18602e11411bf5e6e723df7a2fe4cb513c392da4ec52561"
    sha256 arm64_linux:   "c7726b387e90495e472ba084ea9c20fa14414b9f5a13f0ad2547d76dfdf94ef4"
    sha256 x86_64_linux:  "b38cf02dc15d8362d04a62438d62eb0f6b7be342d83fd349f414b0c24f5f4989"
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
  depends_on "openssl@3"

  uses_from_macos "zlib"

  on_linux do
    depends_on "libx11"
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
