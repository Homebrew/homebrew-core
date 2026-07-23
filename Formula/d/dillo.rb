class Dillo < Formula
  desc "Fast and small graphical web browser"
  homepage "https://dillo-browser.github.io/"
  url "https://github.com/dillo-browser/dillo/releases/download/v3.2.0/dillo-3.2.0.tar.bz2"
  sha256 "1066ed42ea7fe0ce19e79becd029c651c15689922de8408e13e70bb5701931bf"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "133ccf2cba4d0bd952f33b732c18d55cf734e4cc52cdfe1eec378e77c9a4db24"
    sha256 arm64_sequoia: "7dc7ce269edd8f4f14fceaeb32e4778124b9598c7012ff352ade23c8efa0438a"
    sha256 arm64_sonoma:  "a79d60c5478603e8a82cfa50bbce87946c26b671a4d2bc118e1005c5e9ee4329"
    sha256 sonoma:        "8e4b78d3b2f1909881dfcf2fbee7924222a055cf6b863d6d77a6346a127cbf50"
    sha256 arm64_linux:   "affc8edd131cb4d01285085bb413c678ee6ebc0dbf55aebbee6f1abdab7dbae5"
    sha256 x86_64_linux:  "633afe5f018db26138ac0d62cd5d0d55b11fefa78a68bedfc1992718e3ede88b"
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
