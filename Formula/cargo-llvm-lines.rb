class CargoLlvmLines < Formula
  desc "Count lines of LLVM IR per generic function"
  homepage "https://github.com/dtolnay/cargo-llvm-lines"
  url "https://github.com/dtolnay/cargo-llvm-lines/archive/0.4.15.tar.gz"
  sha256 "32fdfdb4eea5f7d9118445a8beadfb1cea2e12c5949766453cee35584afae127"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/dtolnay/cargo-llvm-lines.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0536447d900fc1d9ae9df4c85f9dfc443ad249c68fc97a2597f455262d9afc00"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ebf2b38bb00a4d1258a7861ccd4b9cdb79b41551a2b102ade998d41ed2eadde0"
    sha256 cellar: :any_skip_relocation, monterey:       "340d65137536c7b1ec32349328cb80fdf675ae63a599acf17cfda25ec10e287a"
    sha256 cellar: :any_skip_relocation, big_sur:        "64d3085281f646b672f2f301dec1feaee09e6eb6eb708ee9249dc301da7b11e1"
    sha256 cellar: :any_skip_relocation, catalina:       "925e5b4ddd33b71f5fcefb8b00661ea39796f9595fe81525fae1f4e598850a9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "855169c73fe715b926c3a7afa1fe8921678db5b6b068bcfc9642a28cca6d9cd3"
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
