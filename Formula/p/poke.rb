class Poke < Formula
  desc "Extensible editor for structured binary data"
  homepage "https://jemarch.net/poke"
  url "https://ftp.gnu.org/gnu/poke/poke-4.0.tar.gz"
  sha256 "02bab22cb1fa6153a1b6a927c8bb3cd58d508543c144842a6d7ee74f19973a77"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sonoma:   "02e57bebe24cec6dbaba007e04a2e6d6cb6aa172fdb983804cdd8bae28f67906"
    sha256 arm64_ventura:  "fe36f17d923e77d806a5842aa959a169c758ef6210e474474286e627a60a4165"
    sha256 arm64_monterey: "c7b5c78eb3f40b41043ac15198c96d73aaf2da34936d2c6bf2a2e255354423e4"
    sha256 sonoma:         "1ea600135a0122f8f1ddd81e16f50dbd3fd2b4f39bcede73582c7939964f67dc"
    sha256 ventura:        "a0882981400b9189ee697aaf9ace26295d9fd1bc7efae85c256530f94c32690e"
    sha256 monterey:       "c15b0a7d14b79d222db210791851ee1e1ad4839d88fbcd99de998af9e682a170"
    sha256 x86_64_linux:   "2fb77d8f1757a01f9267725a2202a9c9cb5808b9646bba2d0216c43b84b2b602"
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
