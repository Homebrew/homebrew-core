class Felinks < Formula
  desc "Text mode browser and Gemini, NNTP, FTP, Gopher, Finger, and BitTorrent client"
  homepage "https://github.com/rkd77/elinks#readme"
  url "https://github.com/rkd77/elinks/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "49e261fb7a6b061b51ca38b7152712caba90c8eaa6996bcf4c00fe2867a7f366"
  license "GPL-2.0-only"
  head "https://github.com/rkd77/elinks.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7a070cd5babe443b93682187f5e21a4a7af5511325742051bcf3aeb0dd2b54a0"
    sha256 cellar: :any,                 arm64_big_sur:  "53cba55f13fc1a0116269e0ee3d4008e68e531445a4cbd346372f06ccdee49af"
    sha256 cellar: :any,                 monterey:       "33c90d200713f6b3ea7cfe769b9ed58d12b628e36db1a81b25adb2a3fb41d80e"
    sha256 cellar: :any,                 big_sur:        "d238453ea8cc15e9b620c51b3d8eb04829109cd93972811e6de4da691b6a9f78"
    sha256 cellar: :any,                 catalina:       "78b779010dce7a5329f9e403e6cb542e591a53e190dfd067b4c7074b8cf299b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e83d713d25d71bdca270848cde391df40879c94c1fd84e45c8112ee53e74c27"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "groff" => :build
  depends_on "libtool" => :build
  depends_on "xmlto" => :build

  depends_on "brotli"
  depends_on "libidn"
  depends_on "openssl@1.1"
  depends_on "tre"
  depends_on "zstd"

  uses_from_macos "bison"
  uses_from_macos "bzip2"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  conflicts_with "elinks", because: "both install the same binaries"

  def install
    # https://github.com/rkd77/elinks/issues/47#issuecomment-1190547847 parallelization issue.
    ENV.deparallelize
    system "./autogen.sh"
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
