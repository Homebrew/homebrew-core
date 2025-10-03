class Elfx86exts < Formula
  desc "Decodes x86 binaries (ELF and Mach-O) and prints out ISA extensions in use"
  homepage "https://github.com/pkgw/elfx86exts"
  url "https://github.com/pkgw/elfx86exts/archive/refs/tags/elfx86exts@0.6.2.tar.gz"
  sha256 "55e2ee8c6481e46749b622910597a01e86207250d57e4430b7ce31a22b982e1a"
  license "MIT"
  head "https://github.com/pkgw/elfx86exts.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:elfx86exts@)?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "26364ee7fa3dc23dedbb5ec80e551b0cc406919876a757bf2285e7df6b5f51d6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "082f25260e328fdec04a35804170ad6f0918521c7f146798c0375ff8ee85e7b1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "bb47ed9ed1023b1bfe3caef08bd800517cdfcd146a84a928c792e2b0de88bbae"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0abba15bb99c3a98c80fdc8213eb27d497be4d2c6f419c4a8c4868543553f40f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4dd152a3f044f2d7d80b8af226dccb6757598bc770a8f6fe2d64c44ac25a294"
    sha256 cellar: :any_skip_relocation, sonoma:         "73d0f2b0c4c4ecc122dac0995af34846a1b140a8c604a417f8cbab2a77363a38"
    sha256 cellar: :any_skip_relocation, ventura:        "afb4dc9409919287108a2124cbda2c51b5e7577f965262a50e581afdd9dee9f9"
    sha256 cellar: :any_skip_relocation, monterey:       "6f85234f2d361532a283d8a075325a010facd04013aedb3516cb840c3fcb29b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "1b90574812e7f452dde24120169e1b1616ccfa5120ec206ed336c942e8619bcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f2bd41878fda292054b7c900726aa690f55791e7d541aea2c9cb2cf85b8a0e0"
  end

  depends_on "rust" => :build
  depends_on "capstone"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    expected = <<~EOS
      File format and CPU architecture: Elf, X86_64
      MODE64 (call)
      Instruction set extensions used: MODE64
      CPU Generation: Intel Core
    EOS
    actual = shell_output("#{bin}/elfx86exts #{test_fixtures("elf/hello")}")
    assert_equal expected, actual
  end
end
