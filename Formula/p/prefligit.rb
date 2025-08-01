class Prefligit < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prefligit"
  url "https://github.com/j178/prefligit/archive/refs/tags/v0.0.13.tar.gz"
  sha256 "f5dce3a675e6ec5e0257d88cb989f05a337d18604d14a3eb61a74a6609317329"
  license "MIT"
  head "https://github.com/j178/prefligit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c9e610509b29975dcfd65adff0bb631791103f86ee957740c34135035ea70bfd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32274093e53a44a0597d2aaeff8ae3d39b8e39be786f012f04e2ac85301eeab0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4a04c10f8b9615912920b5016f4db306b2e4d7d8949516227896b678f48769da"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa224f68d6d9d6c15026ff9d80d09c79d4e789fc10982044f8620b73eeceb869"
    sha256 cellar: :any_skip_relocation, ventura:       "99dc7039f3f2da8805bdb9fede2b782a03e41d7a25a90942387a782c08115e46"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2c528d402f1af0d9f63a74814af8eacaa0933e84b74166a40aadcda33622b400"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6d44e1626f329544ed31efe894f6284f0fcd04eb9089bb149e11319bf9c9bb7"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prefligit --version")

    output = shell_output("#{bin}/prefligit sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end
