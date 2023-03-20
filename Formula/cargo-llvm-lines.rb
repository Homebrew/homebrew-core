class CargoLlvmLines < Formula
  desc "Count lines of LLVM IR per generic function"
  homepage "https://github.com/dtolnay/cargo-llvm-lines"
  url "https://github.com/dtolnay/cargo-llvm-lines/archive/0.4.25.tar.gz"
  sha256 "bd9e4d15d82cc6eec7e2811e6ff3e20e6098fbdb3e22e2d9eb1ba5817b19ccab"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-llvm-lines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bfd4bbbcc82ab6c96d30bf545954fc0526fe710cd63ff820e7706d296ea1f9b9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7399330b3eb45ce236164d29940e831dfd72c7ab99e45b66766e08cfe7fb21d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e1940c7e39f70eb3fec0d8412211e747459f51601634e453c018505e1e4f6b1"
    sha256 cellar: :any_skip_relocation, ventura:        "531bf4362047fd310e4d542eb491af9b7f292172d1642344edbe1e3fa9d49d2d"
    sha256 cellar: :any_skip_relocation, monterey:       "ec92da86828eb851784a8a4904e2de2d4d64df00916325dc91b9cc3bc9bf0ec8"
    sha256 cellar: :any_skip_relocation, big_sur:        "da37b2a07f98e7b3671c394f7a69b2a6b409e92e3183e10ef76b85835d47a07d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc84df2995817c7926706de90c95e26b98264b4ad0e3b6942d45dfd1595058fc"
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
