class Felinks < Formula
  desc "Text mode browser and Gemini, NNTP, FTP, Gopher, Finger, and BitTorrent client"
  homepage "https://github.com/rkd77/elinks#readme"
  url "https://github.com/rkd77/elinks/releases/download/v0.15.1/elinks-0.15.1.tar.xz"
  sha256 "cca1864d472f2314dc6ffb40d1f20126f09866a55a0d154961907f054095944f"
  license "GPL-2.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "eea09552d2a9906086e8c1095ca171fcc7f187bd33990bac99fe7e5c3bb86bef"
    sha256 cellar: :any,                 arm64_monterey: "e16bb34d706cb774e454993bcd9b3e7355d0dafa41314bd9893bce0a84dd7ae7"
    sha256 cellar: :any,                 arm64_big_sur:  "674f805753c94b6ae1e4ae3da4d659213e8bbb2b3141d72bb0aed2b3403adf79"
    sha256 cellar: :any,                 ventura:        "a6516e70a3d7c711473b0697b490ea2af62b8fded96004508d1bb6382d42043d"
    sha256 cellar: :any,                 monterey:       "cf7ce03ce6602554161c33dca17bc1ab13cae1f21afea98d185902790ea1a35e"
    sha256 cellar: :any,                 big_sur:        "89e15011eeac39eda0601814203794c416d8033842a32e95cc71330374401063"
    sha256 cellar: :any,                 catalina:       "821c66738ec5fa3549eacf6eac30d3fb508c9d01d1ec6bf375b54805fc8e4f21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a778ac21ccdc917db0bbbfbf7ae7daee9ae56bf10fc9bb81cb3b6cd78ceed9fb"
  end

  head do
    url "https://github.com/rkd77/elinks.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "brotli"
  depends_on "libidn"
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
