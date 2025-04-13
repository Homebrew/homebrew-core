class Cot < Formula
  desc "Rust web framework for lazy developers"
  homepage "https://cot.rs"
  url "https://github.com/cot-rs/cot/archive/refs/tags/cot-v0.2.2.tar.gz"
  sha256 "e0bb713221cbc294a6b51477d2ca54cb9aeb381f43de34244c03107b162771bc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "51667d2ec75320b17f9115f6fe39f4b7af19bb8a27d2ce213bf4271d130b5275"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e74bde63d349de1e09489c0609296f955538bd36b2e80d746817359eefc099f8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a5126ede263141e425a9ff2f873a8a8c72b661a3f2251431ba19da1e36782a6b"
    sha256 cellar: :any_skip_relocation, sonoma:        "3a6dbd24762d373ba27583b736e3fde6ee61af45267844305f0c894c40e02a37"
    sha256 cellar: :any_skip_relocation, ventura:       "15572f7ed85601d2b73125f9ac719b73c32d8e1ba0b429b80ecd134c18d01ac3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1b2d1bc3df69a33aeee9bc3e980345fe567fb0833e99927b431a23bc6f6556d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e47ec43adbc1a6cc0945e11fad5cf4ee5f8b1a325578803a93ee0f778f5e9e33"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cot-cli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cot --version")

    system bin/"cot", "new", "test-project"
    assert_path_exists testpath/"test-project/Cargo.toml"
  end
end
