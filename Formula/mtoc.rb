class Mtoc < Formula
  desc "Mach-O to PE/COFF binary converter"
  homepage "https://opensource.apple.com/"
  url "https://github.com/apple-oss-distributions/cctools/archive/refs/tags/cctools-949.0.1.tar.gz"
  sha256 "8b2d8dc371a57e42852fa6102efaf324ef004adf86072bf9957e2ac9005326c1"
  license "APSL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "04d75f24e8a8dbf876aa37fddd44139c5177b08348210ef3acacedb5ba8e1dc7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebb0ffb0ba60ca6d02f0df9919427bf8a2579632e585a2a6ae851c5fbe858cc5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "935bfd119379ec4d223830db858a2b2279152709a6e78eba895af5859110d22f"
    sha256 cellar: :any_skip_relocation, ventura:        "bd70c47294b5c9bee72d0e7d0c2d1b8779eefd367a01ce13409cbb1191919798"
    sha256 cellar: :any_skip_relocation, monterey:       "fd72c247a0ea992a4ab1a645e3a51007331a1bd15fc693e93fc1bd0267f38273"
    sha256 cellar: :any_skip_relocation, big_sur:        "605abc57733add4e0643d6ffa0186df37e1b4adb5461b9fcdd92d1bfb688f649"
    sha256 cellar: :any_skip_relocation, catalina:       "2f60b3731066cf662f3d8e9451ce0f94954980100780c9e79b6e8ea066ad8def"
    sha256 cellar: :any_skip_relocation, mojave:         "c9cba74c5669816e90ae2fa9110be8c9b6b9d1a90ec7d1f246687a3f512e08ab"
    sha256 cellar: :any_skip_relocation, high_sierra:    "62587e723f38c2a51d3a951dca42df10b9aa1ac67c88d8e286b27e6957edd985"
  end

  deprecate! date: "2022-12-30", because: :unmaintained

  depends_on "llvm" => :build
  depends_on :macos
  conflicts_with "ocmtoc", because: "both install `mtoc` binaries"

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
    system ENV.cc, *args
    system "#{bin}/mtoc", "#{testpath}/test", "#{testpath}/test.pe"
  end
end
