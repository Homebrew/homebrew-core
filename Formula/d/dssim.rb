class Dssim < Formula
  desc "RGBA Structural Similarity Rust implementation"
  homepage "https://github.com/kornelski/dssim"
  url "https://github.com/kornelski/dssim/archive/refs/tags/3.4.0.tar.gz"
  sha256 "5267e79f4604558d9f24ce02aa20597396a9b052d0ad1b2f8000d4d6bd162126"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9eba62a55c801ee782f082e8837e24d7cc7d5753adcb866a7c5bdafde8d96ae"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0acb3332e2cc122f7716f390fdda5942ce072fc76825551d37eb62d401d47d5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6927b9ceeeca235d2ca6c0901aa40f3557ec57b82cb15290e13f5b48860c532c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9efc6c88f8238f85dc0ffa726d7088eb5be0f4a7e0410aa3ba3c39a6d5258f60"
    sha256 cellar: :any_skip_relocation, sonoma:        "a3585108c4c20d7e0af5c07ebb6f3455e4ef29638077a712ddff4cf8f7017e39"
    sha256 cellar: :any_skip_relocation, ventura:       "c7a2d47f9818c50be6379f92773d0677bc4cec873be83b56060f04f159069e19"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a729aa84f38425e25c9e5640c1c18d2980f132d9a52becfede48f9c3003b2359"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cf26940ab54503cb8be6c091610aa90b2e12cd46b05c9a5b8a7a15298ecb190"
  end

  depends_on "nasm" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"dssim", test_fixtures("test.png"), test_fixtures("test.png")
  end
end
