class Oha < Formula
  desc "HTTP load generator, inspired by rakyll/hey with tui animation"
  homepage "https://github.com/hatoo/oha/"
  url "https://github.com/hatoo/oha/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "ef913159c4aa1ee406a4c0d4a07dcedab55f2d7549dcd9839ab112e387601b5a"
  license "MIT"
  head "https://github.com/hatoo/oha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1b4d957ec18ddb623a3696e9beefbabe2482bfb1e2f03eea18002dde7a86de0c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aa37518123bcc6bdd77173023b869e38cb890c4dc29bf83d2c59d7e7e65ef40d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2040b9941609adde8ab9560860c71d8c7c8fb6cd03fb058ed2ff57e884032068"
    sha256 cellar: :any_skip_relocation, sonoma:        "3220c7c0f58adbb044ea250225c2afb91f31a4515838c00001c500ade2d39228"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e6232b87e2d1b7cf9e5b6b3a7b0910d8ed19eedb96711a477bed5772a92130a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2ec60d69ad740f3022eed45800ed7c14ea162245d2cbe225196c0f515ad336ac"
  end

  depends_on "cmake" => :build # for aws-lc-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = "[200] 1 responses"
    assert_match output.to_s, shell_output("#{bin}/oha -n 1 -c 1 --no-tui https://www.google.com")

    assert_match version.to_s, shell_output("#{bin}/oha --version")
  end
end
