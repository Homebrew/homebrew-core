class CargoExpand < Formula
  desc "Show what Rust code looks like with macros expanded"
  homepage "https://github.com/dtolnay/cargo-expand"
  url "https://github.com/dtolnay/cargo-expand/archive/refs/tags/1.0.123.tar.gz"
  sha256 "31901f08b1459dc8460fdca49b8d47a7cdbae9b2835b6de022c50e4ffa9f3367"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-expand.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8efe20de2c6545e1fe9687a449451b731f08acd66f3b2bb53abbc7e419d924d4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6e5c93abd96085bacc16eeffc70a760f0a191e44b3fb206fe53bc91329282a05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c43a28acb7033367c4c3d2f06aa6aaf74e6134a67ebd94f64688017c25d822ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "f59d4f14a26b087df82fff7be5134fbab73ee0cef7adcae6b4dc6491bb49f450"
    sha256 cellar: :any,                 arm64_linux:   "6a96d883b929316f1c8bfa4ca4aee94e427d858734493f5fbbd0edae8f058409"
    sha256 cellar: :any,                 x86_64_linux:  "5af9e00407bc574549598645bddb5819934100a69ae9dfc0fc29348940daf123"
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
