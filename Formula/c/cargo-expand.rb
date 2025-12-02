class CargoExpand < Formula
  desc "Show what Rust code looks like with macros expanded"
  homepage "https://github.com/dtolnay/cargo-expand"
  url "https://github.com/dtolnay/cargo-expand/archive/refs/tags/1.0.118.tar.gz"
  sha256 "d9c412a4dff5052c05ab5afae8e3948f51a8892de121a6fc5c4957dbf599ea05"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-expand.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eccf5f8013596a6fa109d66722e400655fcc00845e84c1b59a61a18df1963017"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ea640cfa397909111bb29d08658950c5aa32049831ef23eb56270728604bc9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7bf5d6ba0b646360a2f4604cc5719b40676f7d2ab3896c577e6993f31211d133"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ddc9072c7f9c58eca6ee2e388bd8ef6bdc36dda7fceaba05f15caff32306dba"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5243cda443ca4b58cac6930c1a48f79b20644b2401acf55bcad1e40c4c5890e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3781dfaca54afef9a33b0fd12ad00552894d6b84e026e0e757b1149f7a2a6bb"
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
