class Corrosion < Formula
  desc "Easy Rust and C/C++ Integration"
  homepage "https://github.com/corrosion-rs/corrosion"
  url "https://github.com/corrosion-rs/corrosion/archive/refs/tags/v0.5.tar.gz"
  sha256 "d225753d54b482e04d2eb9e1a56f4b569d20dc70b00481dec279de1b5baa02f0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0cdcb66217afc2d3c369bd4cbaa97aa2bc66221ec3b51ab716d38a0a9cc03c7e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d531a2a4a85f1bad53e797ec22fa3b09e99455c3f768b9a67c4291ad36ade9ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec6c73422174eafe97b1aa344c43c7154262b6593c013740608d4a0cd4d1c925"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5dda963ae5656cde3da9a5cb6923765d75e9fefbec5e85b4295552a9b402261"
    sha256 cellar: :any_skip_relocation, sonoma:         "e0f08c4ce5fb360b3a812840caf5e1ae30fdb22a0cdeb55e0b6cc28daf580dba"
    sha256 cellar: :any_skip_relocation, ventura:        "795542e04976a74ac3a5a2f161c627eed210dfdccbd4f5d49b0dc277c8c93d35"
    sha256 cellar: :any_skip_relocation, monterey:       "0a94b4efb02cab9d60da080527c6dcbc118a4bf83451435d90d96236c0bf39e4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8f17b3ca11c86ca26efd75a07c36e2e68bbc948ad65770423fe62ef9aa6f1c3"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "rust" => [:build, :test]

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test/rust2cpp/rust2cpp/.", testpath
    inreplace "CMakeLists.txt", "include(../../test_header.cmake)", "find_package(Corrosion REQUIRED)"
    system "cmake", "."
    system "cmake", "--build", "."
    assert_match "Hello, Cpp! I'm Rust!", shell_output("./cpp-exe")
  end
end
