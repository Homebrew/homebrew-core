class Nasm < Formula
  desc "Netwide Assembler (NASM) is an 80x86 assembler"
  homepage "https://www.nasm.us/"
  url "https://www.nasm.us/pub/nasm/releasebuilds/2.16.03/nasm-2.16.03.tar.xz"
  sha256 "1412a1c760bbd05db026b6c0d1657affd6631cd0a63cddb6f73cc6d4aa616148"
  license "BSD-2-Clause"

  livecheck do
    url "https://www.nasm.us/pub/nasm/releasebuilds/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "7f641dcb5ae03d3eebbfe11b3284a1b655f794f79a9aabf8c396003d8940d059"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c04988e99839f591ced743c876289c18fb403b3a6826effaa3a0a9ba9385ddbc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "265e501fd778167b9c9122097acbf94c0d0577b8c5e2e94722d88cc89a07ba3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f354fd20ce32d149d1fe08b9cc5ba1c1facdd19d6c3ee16c88ecdeaef3d012e2"
    sha256 cellar: :any_skip_relocation, sonoma:         "81b2abb78f56dc299b3cd69a8626b04997f6fd06df71f3d56058331089a58a4e"
    sha256 cellar: :any_skip_relocation, ventura:        "79b87e6bfcb38df38909219e8ae172e970324236074912a5a23704449e5e097b"
    sha256 cellar: :any_skip_relocation, monterey:       "7d00b410fdb6d366f344057cb17fa58b5d65c6ee888394bd14c5e210122d0b8a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "138876a9a24c01fda90cecba6aaba7b6e8e94e95768215338e709cc63b80821c"
  end

  head do
    url "https://github.com/netwide-assembler/nasm.git", branch: "master"
    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "xmlto" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "manpages" if build.head?
    system "make", "install"
  end

  test do
    (testpath/"foo.s").write <<~EOS
      mov eax, 0
      mov ebx, 0
      int 0x80
    EOS

    system bin/"nasm", "foo.s"
    code = File.open("foo", "rb") { |f| f.read.unpack("C*") }
    expected = [0x66, 0xb8, 0x00, 0x00, 0x00, 0x00, 0x66, 0xbb,
                0x00, 0x00, 0x00, 0x00, 0xcd, 0x80]
    assert_equal expected, code
  end
end
