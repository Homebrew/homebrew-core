class CargoLlvmLines < Formula
  desc "Count lines of LLVM IR per generic function"
  homepage "https://github.com/dtolnay/cargo-llvm-lines"
  url "https://github.com/dtolnay/cargo-llvm-lines/archive/0.4.16.tar.gz"
  sha256 "284fbd1d16c52392e2eb3b0a29a05be244672b0f8eb3b70447ae7840604419a4"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-llvm-lines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf9420ad335b74ab9656f2742af743651e6a5bd00acf0ca6fa72f6dab212156f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e155ddac240b2bc415a8bbe1fcd5b5df8ed66bf89588f4ba8122f741b9f59332"
    sha256 cellar: :any_skip_relocation, monterey:       "6f11fb36e838e53b9d8ba38dd9fa1b5a3f9b6350c76990691f8c524c43e8d7c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "686010132a20c7991e84320868aad3a3f8d11cd717631c6dbfb4ca476e79bec7"
    sha256 cellar: :any_skip_relocation, catalina:       "4e17d0e031704e6dc1bbb2e10f24616cc2af0009ac6773db1ae16157d115b016"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b39d87094306be849e0835f3c5dc10291d389494f3db722df8d1eecc9e341fe"
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
