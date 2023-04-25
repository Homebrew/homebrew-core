class Poke < Formula
  desc "Extensible editor for structured binary data"
  homepage "https://jemarch.net/poke"
  url "https://ftp.gnu.org/gnu/poke/poke-3.1.tar.gz"
  sha256 "f405a6ba810916ec717000b6fe98ef10cbe549bf0a366b3f81e1f176ff8ff13f"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "8dbf2f764a89f9a48e71c4b0a67c445528b01361e2e35d8ed66e96c8d19d55e1"
    sha256 arm64_monterey: "f1687364a8488028309f5cba4cdc337f235ccd9d1109365ae31fb6c3f25e2543"
    sha256 arm64_big_sur:  "b2fdb09b7f04f33de743432bbc281f45de5dc114efbb89c4a4d1b215acad2b29"
    sha256 ventura:        "4a642521007388ae32ae44d830ace4b77d912045d84444ca0acce079c341449e"
    sha256 monterey:       "c95fcce2c2703c92a6e7b6d282ba4ea6694f95699e49b9328b7087f7a866d9ca"
    sha256 big_sur:        "a1680572316ffdab024790db422b52ad851afc1196ea8306af0cba4ad00536f3"
    sha256 x86_64_linux:   "6237fca4157fec752f2c945ba2b5237f8a45f7509dc672ba4c8b1a925351db5b"
  end

  depends_on "pkg-config" => :build
  depends_on "bdw-gc"
  depends_on "gettext"
  depends_on "readline"

  uses_from_macos "ncurses"

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules", "--with-lispdir=#{elisp}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.pk").write <<~EOS
      .file #{bin}/poke
      dump :size 4#B :ruler 0 :ascii 0
      .exit
    EOS
    if OS.mac?
      assert_match "00000000: cffa edfe", shell_output("#{bin}/poke --quiet -s test.pk")
    else
      assert_match "00000000: 7f45 4c46", shell_output("#{bin}/poke --quiet -s test.pk")
    end
  end
end
