class Nasm < Formula
  desc "Netwide Assembler (NASM) is an 80x86 assembler"
  homepage "https://www.nasm.us/"
  url "https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/nasm-2.15.05.tar.xz"
  sha256 "3caf6729c1073bf96629b57cee31eeb54f4f8129b01902c73428836550b30a3f"
  license "BSD-2-Clause"

  livecheck do
    url "https://www.nasm.us/pub/nasm/releasebuilds/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea233a725bc6ecde3e61967f64d1ffad54e17a3cf3947b700b8d4a46ef9bc310"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b890027bb7fef2cf20c69f3fd38ed0c19c373bce79c949ab6d123601617ae949"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e3fb019ffdfcd4ce6b418adbe3d1d1d0e1e232a7de3b62fc4872c2401543cb3"
    sha256 cellar: :any_skip_relocation, ventura:        "39cfdb815cf5285b57f62f149abab2da481ca72c4b28fd8aac7cc65d6d1a1280"
    sha256 cellar: :any_skip_relocation, monterey:       "d22292dce7f323c908b6774fbc76c4716142e2b73a292556e22d3b42589fd5d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc45793ac9f3fedd01dd08bbbf766137a40bf22e18c43742498b0a542aa319e8"
    sha256 cellar: :any_skip_relocation, catalina:       "1875e67160bac1675dd505d66a6b78469767d2dfe8baab2652409f91ac0549ef"
    sha256 cellar: :any_skip_relocation, mojave:         "4b3614f857264edfa9aeab961c523b3910cdef0ceccaf9957888b477c1c512f4"
    sha256 cellar: :any_skip_relocation, high_sierra:    "8f8c181994b1f05bf425a4034f76d6973c9e1a85ecb64af7f67d47556f23a0d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21fd7041a27b500983d56bf9b24739790f5de243da14a4a549a2afb3ed23deb4"
  end

  head do
    url "https://github.com/netwide-assembler/nasm.git"
    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "xmlto" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "manpages" if build.head?
    system "make", "rdf"
    system "make", "install", "install_rdf"
  end

  test do
    (testpath/"foo.s").write <<~EOS
      mov eax, 0
      mov ebx, 0
      int 0x80
    EOS

    system "#{bin}/nasm", "foo.s"
    code = File.open("foo", "rb") { |f| f.read.unpack("C*") }
    expected = [0x66, 0xb8, 0x00, 0x00, 0x00, 0x00, 0x66, 0xbb,
                0x00, 0x00, 0x00, 0x00, 0xcd, 0x80]
    assert_equal expected, code
  end
end
