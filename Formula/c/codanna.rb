class Codanna < Formula
  desc "Code intelligence system with semantic search"
  homepage "https://github.com/bartolli/codanna"
  url "https://github.com/bartolli/codanna/archive/refs/tags/v0.9.19.tar.gz"
  sha256 "7eccc35f184e90fc1b48f390ba4f817fd86164ac6f5e7084b23764eef62268ac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb8b2b20d77219285988503a98d0c08e6ca6fdb6c3cd9c8f9a2065814286d105"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2810b847cb875c1893792e0b03fb6502e179ef12a75270f66e2f7e889e22268d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cad5eb939cf4f6cbc03beb62025603a2aaf7254069b0df5b32c056b5d4e7c11a"
    sha256 cellar: :any_skip_relocation, sonoma:        "3607dda99af48e001e74c48da2ba577ec59302afaa61dd2f501819746e377227"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a51932475db20d4903e36f6ec091561a49993e8a96dda993c166815788f69bc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c46ad6477fda64d97bc4ee519fac4a8e4a97bbfe4e80179236e27a873efa7198"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "cargo", "install", *std_cargo_args, "--all-features"
  end

  test do
    system bin/"codanna", "init"
    assert_path_exists testpath/".codanna"
  end
end
