class Felinks < Formula
  desc "Text mode browser and Gemini, NNTP, FTP, Gopher, Finger, and BitTorrent client"
  homepage "https://github.com/rkd77/elinks#readme"
  url "https://github.com/rkd77/elinks/releases/download/v0.16.1.1/elinks-0.16.1.1.tar.xz"
  sha256 "303c6f830b98658dcb813b68432ecde27d3857ccf1e765109fb6b0edb89f5095"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a6115add8e76c8dacc68deb68ca62f97a491d42eec37c325555e4b928cf9f571"
    sha256 cellar: :any,                 arm64_monterey: "7022a233634adae1b93d4e6d8796dff37666ae11a6cd01d1e2fca859090822aa"
    sha256 cellar: :any,                 arm64_big_sur:  "a7d6126a3fb6fa700cefc46ba323b94bcc93ad479a59e7dc41deedbad3c35130"
    sha256 cellar: :any,                 ventura:        "0834b3a35b8f5a8c1760f0d63cc2bf3bd2ae49c9c8da68320df8486e0c34a34e"
    sha256 cellar: :any,                 monterey:       "830cc73a8e8dfad7aaae3271636f1646d60292b0e42ee398d59944d20e61add2"
    sha256 cellar: :any,                 big_sur:        "2e48a8a05c023118d94094dfa8e3c0065fe51746e54fa16cb182a88be269ff90"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3f9f998591f4be38178e2fc160a43192e5b369c16628269f281a2e66bf76a59"
  end

  head do
    url "https://github.com/rkd77/elinks.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "brotli"
  depends_on "libidn2"
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
