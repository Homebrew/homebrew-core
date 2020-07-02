class Mtoc < Formula
  desc "Mach-O to PE/COFF binary converter"
  homepage "https://opensource.apple.com/source/cctools/cctools-949.0.1/"
  url "https://opensource.apple.com/tarballs/cctools/cctools-949.0.1.tar.gz"
  sha256 "830485ac7c563cd55331f643952caab2f0690dfbd01e92eb432c45098b28a5d0"

  bottle do
    cellar :any_skip_relocation
    sha256 "9633efa04b078ac1353ec39db86cdfa98e98024f671ac8a46457c8cd27925bbe" => :catalina
    sha256 "976565f15269c96da91a36c9f5b7e2497741f44f1ca1ec2c2402fe8d430a072d" => :mojave
    sha256 "883674b5bfc549ef5ce33fc4ca653cd0d5583319d57beb170763d5b331ed6919" => :high_sierra
  end

  depends_on "llvm" => :build

  patch do
    url "https://raw.githubusercontent.com/acidanthera/ocbuild/d3e57820ce85bc2ed4ce20cc25819e763c17c114/patches/mtoc-permissions.patch"
    sha256 "0d20ee119368e30913936dfee51055a1055b96dde835f277099cb7bcd4a34daf"
  end

  def install
    system "make", "LTO=", "EFITOOLS=efitools", "-C", "libstuff"
    system "make", "-C", "efitools"
    system "strip", "-x", "efitools/mtoc.NEW"

    bin.install "efitools/mtoc.NEW" => "mtoc"
    man1.install "man/mtoc.1"
  end

  test do
    (testpath/"test.c").write <<~EOS
      __attribute__((naked)) int start() {}
    EOS

    args = %W[
      -nostdlib
      -Wl,-preload
      -Wl,-e,_start
      -seg1addr 0x1000
      -o #{testpath}/test
      #{testpath}/test.c
    ]
    system "cc", *args
    system "#{bin}/mtoc", "#{testpath}/test", "#{testpath}/test.pe"
  end
end
