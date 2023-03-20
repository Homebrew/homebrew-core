class Felinks < Formula
  desc "Text mode browser and Gemini, NNTP, FTP, Gopher, Finger, and BitTorrent client"
  homepage "https://github.com/rkd77/elinks#readme"
  license "GPL-2.0-only"

  # TODO: Switch to `libidn2` on next release and remove stable block
  stable do
    url "https://github.com/rkd77/elinks/releases/download/v0.16.0/elinks-0.16.0.tar.xz"
    sha256 "4d65b78563af39ba1d0a9ab1c081e129ef2ed541009e6ff11c465ba9d8f0f234"
    depends_on "libidn"
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "161812829640eb38d7b3cc8745a357dde5c5504d5c275b024a39c7d765cbf6ac"
    sha256 cellar: :any,                 arm64_monterey: "a0f23116d119af283254276777bc0e15a212ff734ea62162638f5f90a9c693e9"
    sha256 cellar: :any,                 arm64_big_sur:  "a019ea4cddf3176b28231e2fed2618a0dcd0ebbaebe11a51cdb764871e311011"
    sha256 cellar: :any,                 ventura:        "6b26c82e2c6caa670821b65f559e717cc07a509baf7097d7cb8805cdb3c7dc31"
    sha256 cellar: :any,                 monterey:       "6e9bf6181366d6326f086453fae724f0f22c0ea72d6efac56c00e928a7e61760"
    sha256 cellar: :any,                 big_sur:        "bdd387e06cfefa3f3990fd59b08c8d94ca9a5b48ef9cd19876d3db1ff976fe0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "065972f98316dabbeb4f753183a4b3a0e7915f5f9168389282e19bc453b4626e"
  end

  head do
    url "https://github.com/rkd77/elinks.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libidn2"
  end

  depends_on "pkg-config" => :build
  depends_on "brotli"
  depends_on "openssl@3"
  depends_on "tre"
  depends_on "zstd"

  uses_from_macos "bison" => :build
  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  conflicts_with "elinks", because: "both install the same binaries"

  def install
    # https://github.com/rkd77/elinks/issues/47#issuecomment-1190547847 parallelization issue.
    ENV.deparallelize
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args,
                          "--disable-nls",
                          "--enable-256-colors",
                          "--enable-88-colors",
                          "--enable-bittorrent",
                          "--enable-cgi",
                          "--enable-exmode",
                          "--enable-finger",
                          "--enable-gemini",
                          "--enable-gopher",
                          "--enable-html-highlight",
                          "--enable-nntp",
                          "--enable-true-color",
                          "--with-brotli",
                          "--with-openssl",
                          "--with-tre",
                          "--without-gnutls",
                          "--without-perl",
                          "--without-spidermonkey",
                          "--without-x",
                          "--without-xterm"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.html").write <<~EOS
      <!DOCTYPE html>
      <title>Hello World!</title>
      Abracadabra
    EOS
    assert_match "Abracadabra",
      shell_output("#{bin}/elinks -dump test.html").chomp
  end
end
