class Mtoc < Formula
  desc "Mach-O to PE/COFF binary converter"
  homepage "https://opensource.apple.com/source/cctools/cctools-949.0.1/"
  url "https://opensource.apple.com/tarballs/cctools/cctools-949.0.1.tar.gz"
  sha256 "830485ac7c563cd55331f643952caab2f0690dfbd01e92eb432c45098b28a5d0"

  livecheck do
    url "https://opensource.apple.com/tarballs/cctools/"
    regex(/href=.*?cctools[._-]v?(\d+(?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebb0ffb0ba60ca6d02f0df9919427bf8a2579632e585a2a6ae851c5fbe858cc5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "935bfd119379ec4d223830db858a2b2279152709a6e78eba895af5859110d22f"
    sha256 cellar: :any_skip_relocation, monterey:       "fd72c247a0ea992a4ab1a645e3a51007331a1bd15fc693e93fc1bd0267f38273"
    sha256 cellar: :any_skip_relocation, big_sur:        "605abc57733add4e0643d6ffa0186df37e1b4adb5461b9fcdd92d1bfb688f649"
    sha256 cellar: :any_skip_relocation, catalina:       "2f60b3731066cf662f3d8e9451ce0f94954980100780c9e79b6e8ea066ad8def"
    sha256 cellar: :any_skip_relocation, mojave:         "c9cba74c5669816e90ae2fa9110be8c9b6b9d1a90ec7d1f246687a3f512e08ab"
    sha256 cellar: :any_skip_relocation, high_sierra:    "62587e723f38c2a51d3a951dca42df10b9aa1ac67c88d8e286b27e6957edd985"
  end

  depends_on "llvm" => :build
  depends_on :macos

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
