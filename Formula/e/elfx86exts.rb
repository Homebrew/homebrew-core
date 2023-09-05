class Elfx86exts < Formula
  desc "Decodes x86 binaries (ELF and Mach-O) and prints out ISA extensions in use"
  homepage "https://github.com/pkgw/elfx86exts"
  url "https://github.com/pkgw/elfx86exts/archive/refs/tags/elfx86exts@0.5.0.tar.gz"
  sha256 "e09c3b7a08b7034859d4d56d0fbfa1d0c45b3df3d4345af51cca05d1f7d80766"
  license "MIT"
  head "https://github.com/pkgw/elfx86exts.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:elfx86exts@)?v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8680dbd22fcccac5b1b11ea34f2e812f8736261a094802521cd746ddb8ca1fa1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e787acd4405cf44c00986c85702d8dd4b77a247122a770c04c579b731a436c69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86c69958793913345e7b5559cae950b9ce4c8834bbd457b2d5be7a4082f819d2"
    sha256 cellar: :any_skip_relocation, ventura:        "f81d09003f7a89641675dddee66f243fa30368d8d629c3fb3cc6e706200a1880"
    sha256 cellar: :any_skip_relocation, monterey:       "fb5614cd1479da8b6432cce92774439ccb8d95529aad981f926fe0361679be13"
    sha256 cellar: :any_skip_relocation, big_sur:        "f06642868d5e4b81af3e51bdf4f1956c018fd66da15ed68f9b12b6f82e60e60a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9994e41bd2fd391a5fc0dde2ada4fac0b0f93b6b15f88364b5864b868dba83b"
  end

  depends_on "rust" => :build
  depends_on "capstone"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    expected = <<~EOS
      MODE64 (call)
      CPU Generation: Intel Core
    EOS
    actual = shell_output("#{bin}/elfx86exts #{test_fixtures("elf/hello")}")
    assert_equal expected, actual
  end
end
