class CargoLlvmLines < Formula
  desc "Count lines of LLVM IR per generic function"
  homepage "https://github.com/dtolnay/cargo-llvm-lines"
  url "https://github.com/dtolnay/cargo-llvm-lines/archive/0.4.14.tar.gz"
  sha256 "1dc5a726b3b7b3ac2d01e190e605415b394c95cc44144fb91ddea643d35eda78"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-llvm-lines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5387b744741a358b7bf4dad974b03f288881c84318382c5af1be7451f3cfa90b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8892a936a1e37e411e30df692ded2008e0d2fab6463dd8b26bc202a7674b94df"
    sha256 cellar: :any_skip_relocation, monterey:       "329f5f585ca9747b576ee00623eb004f932b2f0f3daabdd7abfc5248fc9c7fb0"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d80d9b3ba3f4b52a9f642f4953267b895979f6d18527576fafe06fd67bd7a2f"
    sha256 cellar: :any_skip_relocation, catalina:       "3fa2c275547f8349b43dd0a150abb8e44ae7f483f5c0f41fc6f0e754bd7e086b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3aec84fdf195cf6330cf640aa0fe6c04a55e52e43e5e7e5ab8f11cc0a0a06aef"
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
