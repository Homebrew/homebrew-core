class Dssim < Formula
  desc "RGBA Structural Similarity Rust implementation"
  homepage "https://github.com/kornelski/dssim"
  url "https://github.com/kornelski/dssim/archive/3.0.0.tar.gz"
  sha256 "ad2498d4b73d3e5210491750b82cdee833ec25ddab38f76a6dc46b21e0e572fa"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "919d94af16d5c1b81bf3368819ac71d73cb404fcef347fe90cdefcc1f5bd7f4f"
    sha256 cellar: :any_skip_relocation, catalina: "3bbf4c9dc9acf08ea2f16a2ba393fd2a0b90b6a675555cecb3095136b7361938"
    sha256 cellar: :any_skip_relocation, mojave:   "3610c3253c0838fd558d6d8fdd95913d068458869f8600c88f60fb3021d980a0"
  end

  depends_on "nasm" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "#{bin}/dssim", test_fixtures("test.png"), test_fixtures("test.png")
  end
end
