class CargoExpand < Formula
  desc "Show what Rust code looks like with macros expanded"
  homepage "https://github.com/dtolnay/cargo-expand"
  url "https://github.com/dtolnay/cargo-expand/archive/refs/tags/1.0.109.tar.gz"
  sha256 "e74de038564b2c38923fde020876d69e4f53e127b708198910f14673f1b86139"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-expand.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e65cb1237be60c47969e8cdab87da4134adaa9b8ddca72822fd2f89a4977fd3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71fdfff6d5f1b6a85bbeaf21f3a868c0e77788003c35b27f7899e24bda83d175"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ce681e4cb7f08efe1125b1123f12c268f3401af06540cafac3a6d68c9671b308"
    sha256 cellar: :any_skip_relocation, sonoma:        "6672aab651c3fcab1d56b1c75d758143aaff448569f46f25196e67d7cbb2eb93"
    sha256 cellar: :any_skip_relocation, ventura:       "6f1e9126dbd6c264db65a8334860dcec6cba1c6818a6bc39fd0c6a7845db1ef1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1203aeaa1e0b034d65cbb2b007d07ff40e29b3f9f27a40313865d140f23785bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "054d6857fac5fea9cec7023457b48240126445747a7238a42231a3836383522f"
  end

  depends_on "rust" => :build
  depends_on "rustup" => :test

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV.prepend_path "PATH", Formula["rustup"].bin
    system "rustup", "set", "profile", "minimal"
    system "rustup", "default", "stable"

    system "cargo", "new", "hello_world", "--lib"
    cd "hello_world" do
      output = shell_output("cargo expand 2>&1")
      assert_match "use std::prelude", output
    end
  end
end
