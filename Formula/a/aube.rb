class Aube < Formula
  desc "Fast Node.js package manager"
  homepage "https://aube.en.dev"
  url "https://github.com/jdx/aube/archive/refs/tags/v1.39.0.tar.gz"
  sha256 "db77d64748fa834c76a67a846b7dec0f4fdfc48cd3a1d2274b3ba92079d030bf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2e056b8c45fb8f7ca25e440564ea541fbbbd7906bc233645cdb2c8a791c301e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f7115d36472703e0ac11889d2e1c91a1a35014488bdcbe74cbfd5b5943f3efc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "feb42ed64bb7ecea24ccdf502cef39cec58c1fc54c5cd9ca52dd032fce14dc64"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f0252b77c8aed67326b44653ad37662c6e45690a94d9ef759471ce7d52939a5"
    sha256 cellar: :any,                 arm64_linux:   "3b773ebb49ff27ae8e8032bbb20191ccc58b6d9ad66feff2b6a12df124c023fc"
    sha256 cellar: :any,                 x86_64_linux:  "e69d1d42a36d2320ff7bb162e4e5a6f9e84146b12cf3228db4ef5229234a440e"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "usage" => :build
  depends_on "node" => :test

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/aube")
    generate_completions_from_executable(bin/"aube", "completion")
  end

  test do
    system bin/"aube", "init", "--bare"
    system bin/"aube", "add", "cowsay"
    assert_path_exists testpath/"node_modules/cowsay"
    assert_match "< moo >", shell_output("#{bin}/aubx cowsay moo")
  end
end
