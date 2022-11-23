class CargoLlvmLines < Formula
  desc "Count lines of LLVM IR per generic function"
  homepage "https://github.com/dtolnay/cargo-llvm-lines"
  url "https://github.com/dtolnay/cargo-llvm-lines/archive/0.4.22.tar.gz"
  sha256 "af963e70574b9fc1fd6570df8df875bf00d3bcbf2435a7e86920fdb762cb3764"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-llvm-lines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ce5bf04339b565f2ed9d1ce643536856e914f519a39966ad6b8979345870f41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "002a58e20089d8a7483e37280317f39b6b5a96a8b5d441876bcbd14f9780bbe9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b35416eef705850d5ac2e51e1f0715e0c9a95b94c578ea66508dc41609c31d72"
    sha256 cellar: :any_skip_relocation, monterey:       "4c0c9ea8b97bdbe33805faf944680d141746a8fcdf332070784e40b9818bfffb"
    sha256 cellar: :any_skip_relocation, big_sur:        "e27f31467c219637410440515776464a5c0f0537bbb688e8447625bd9285079f"
    sha256 cellar: :any_skip_relocation, catalina:       "3405955b474189e5dfa59b6870059a5543251120dc5178faf81de2b708b04efc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe0b2e7f11ccfd619808b957cd65f29bf4c589a136fda3d91f60f58b821d5fde"
  end

  depends_on "rust"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      output = shell_output("cargo llvm-lines 2>&1")
      assert_match "core::ops::function::FnOnce::call_once", output
    end
  end
end
