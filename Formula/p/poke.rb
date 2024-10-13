class Poke < Formula
  desc "Extensible editor for structured binary data"
  homepage "https://jemarch.net/poke"
  url "https://ftp.gnu.org/gnu/poke/poke-4.2.tar.gz"
  sha256 "8aaf36e61e367a53140ea40e2559e9ec512e779c42bee34e7ac24b34ba119bde"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_sequoia:  "485e1190a1f78a2ff42555c899ae69c6a85d0eddfabe5cc0db5b75406b523a2a"
    sha256 arm64_sonoma:   "83f4976a5a44529059e78a544632ab5848fcb3c705d5e70e91db0136344319a4"
    sha256 arm64_ventura:  "a500fc9175ce7d850b6740b81fa6f1a32f3b6672490883c00590884154b35d4f"
    sha256 arm64_monterey: "7fbb646c34866360030ba47081a061f3bf2dc2bd9a5c427c238c253de51f7700"
    sha256 sonoma:         "c7316c243e71fe22e5e91e3142f2e67ec68d58bb88cc148fb9bb21bcf85fdccc"
    sha256 ventura:        "795e9c8f88627a655ad7c0a5327731283d624259f77db86db838f69c93aa95b8"
    sha256 monterey:       "8932a216598088d7505fc7c74f8e5f5c57737b689d164fd9febc4dbcf40e4225"
    sha256 x86_64_linux:   "492e0262c792aa4e2b6c3cd68124acff4ef85613715b6b1c1f5d23ddb77fa3c6"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "help2man" => :build
  depends_on "libtool" => :build
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
