class Cracklib < Formula
  desc "LibCrack password checking library"
  homepage "https://github.com/cracklib/cracklib"
  url "https://github.com/cracklib/cracklib/releases/download/v2.9.10/cracklib-2.9.10.tar.bz2"
  sha256 "9e0f2546220c6023754d81e5110c87192f92c703a2b0cc58661cd82dbcf07c63"
  license "LGPL-2.1-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "8ca774724498f70bb4f34c8893b61be3ac3d41c3b6040f1431ebbc8db3bf8d2d"
    sha256 arm64_monterey: "658c4a874fa775f928bb3c86eff99d24f6fcc3e5ecac33f40ac8368db84cbbfa"
    sha256 arm64_big_sur:  "3f221c7ba8a31115dad437f5dc82a9d15d148e743dfe20e822d52c93a0dede62"
    sha256 ventura:        "101f0e6a1bec6b53a0d7bff50e2ef36cc68e9cc3683118559f42f042732a90b1"
    sha256 monterey:       "92ecee7e1a637d15c5a5a5cc4a8b86a36d0dc62d938b0ae9121d03d2a3788ecc"
    sha256 big_sur:        "134a461907a2d6aaa5d4460dfd1f007a99847f4f8726317eb426f8184cc32b28"
    sha256 x86_64_linux:   "9f7a571451eb64a73e74f9689d9a3c2517361c1f8634488daba5ee41efe9a64b"
  end

  depends_on "gettext"

  resource "cracklib-words" do
    url "https://github.com/cracklib/cracklib/releases/download/v2.9.10/cracklib-words-2.9.10.bz2"
    sha256 "19a557eb482332a4499267d9e25089a76bfb9e2bdea7ecf62ea6b6df4fb4c118"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--sbindir=#{bin}",
                          "--without-python",
                          "--with-default-dict=#{var}/cracklib/cracklib-words"
    system "make", "install"

    share.install resource("cracklib-words")
  end

  def post_install
    (var/"cracklib").mkpath
    cp share/"cracklib-words-#{version}", var/"cracklib/cracklib-words"
    system "#{bin}/cracklib-packer < #{var}/cracklib/cracklib-words"
  end

  test do
    assert_match "password: it is based on a dictionary word", pipe_output("#{bin}/cracklib-check", "password", 0)
  end
end
