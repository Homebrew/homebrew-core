class Poke < Formula
  desc "Extensible editor for structured binary data"
  homepage "https://jemarch.net/poke"
  url "https://ftp.gnu.org/gnu/poke/poke-3.3.tar.gz"
  sha256 "0080459de85063c83b689ffcfba36872236803c12242d245a42ee793594f956e"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_ventura:  "a88a2508d3dddc7e4ec7f6a1127b09c33b0a31d071e7dd2a25095a808681b5dc"
    sha256 arm64_monterey: "81de3d285f045c30526092a8e8fe30e8498b149b7684cc2aeb4859ec08769d13"
    sha256 arm64_big_sur:  "10c70e57d91e1ba919e02b10cfc8568b2c00b5b1418b575816a5f04bffcae067"
    sha256 ventura:        "5e6b38c7b29f95b85ed4cda0b047db50a2d849d60b4f85eb90e7a91246710760"
    sha256 monterey:       "472e62f3691745a9f7675ad43b7717dd14c14fe3517ab358fe476954d87b937d"
    sha256 big_sur:        "9f2bd469ff64b420f47ea4a221d0c0ed9694b689e00190f43c4a4bd03155d028"
    sha256 x86_64_linux:   "bef1d1a72b55baa12c041359f8602aea5ce7afcfaa5a39b6e97087339b57ed70"
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
