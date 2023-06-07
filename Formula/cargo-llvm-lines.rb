class CargoLlvmLines < Formula
  desc "Count lines of LLVM IR per generic function"
  homepage "https://github.com/dtolnay/cargo-llvm-lines"
  url "https://github.com/dtolnay/cargo-llvm-lines/archive/0.4.29.tar.gz"
  sha256 "6d5a1dad0e38e7d473acfabdc28ea92462bf5099b6397feae18c4fc43f93feb7"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-llvm-lines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3583beea8eda0d585a1ec55697b45c8778cec4ed1353325a58bde1de96f97348"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "499abc92f6bd41925643dd16ccf2d28d9c728deeffc55637fa6598efaff6b7de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fac61c9baa81af7bff17818e34ead7b85def0c30b5c0882d861a72dad098ca64"
    sha256 cellar: :any_skip_relocation, ventura:        "7949db44fd1ddf95940b3b7095d4b5b7a2a8fc40d33ed8ec6753d8c594531880"
    sha256 cellar: :any_skip_relocation, monterey:       "824c05a98ca63a8f69c7e351a71055b6d622db48f251fe7fa62cd7e5d963c1db"
    sha256 cellar: :any_skip_relocation, big_sur:        "aaad118ed8afdf4cb7abb19ce103f59ae0d408924d235f20c26a9adf8dce494d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62dc3b101b6f3204936797898a067280f7b492f820af9fd8a98a15f1f0d1341a"
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
