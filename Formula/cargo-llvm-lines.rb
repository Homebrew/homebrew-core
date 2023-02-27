class CargoLlvmLines < Formula
  desc "Count lines of LLVM IR per generic function"
  homepage "https://github.com/dtolnay/cargo-llvm-lines"
  url "https://github.com/dtolnay/cargo-llvm-lines/archive/0.4.25.tar.gz"
  sha256 "bd9e4d15d82cc6eec7e2811e6ff3e20e6098fbdb3e22e2d9eb1ba5817b19ccab"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-llvm-lines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9306a03592fb2dde71f28bdb3d8f3c300e4eaa3d2d0498a0d755c9bf26296bb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d1189a50ff22e7a5a9405564ed8e14f96a3da95e899f45fec26d238bd6ea0657"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3f81ec0778cbd7c564bf539038a3413d4779f103782f74d90da72d232548cf95"
    sha256 cellar: :any_skip_relocation, ventura:        "0db34c8c3d58ff12c89c8cfdcef25a97dd3ac2eb8a171f1dc6e5b3bf0704eb59"
    sha256 cellar: :any_skip_relocation, monterey:       "76eeb259e7be8f379463a32f295ffbef6f3dd7870a4af4c609dbb565f7ee4ce4"
    sha256 cellar: :any_skip_relocation, big_sur:        "05cbab0e251c2158631aaaaee52439febcd6783e3b2c63d4086bb0592cd904a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53789e735dad1a57275d2c16c92ce8b6332f65d440d9f3d74c66664fca134b29"
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
