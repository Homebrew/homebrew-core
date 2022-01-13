class Binaryen < Formula
  desc "Compiler infrastructure and toolchain library for WebAssembly"
  homepage "https://webassembly.org/"
  url "https://github.com/WebAssembly/binaryen/archive/version_105.tar.gz"
  sha256 "c5ec27c157d3b33ce4360607cc6afe565fa490094237895db2162b3a7d667da2"
  license "Apache-2.0"
  head "https://github.com/WebAssembly/binaryen.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "941ecdab783c2d8bc556645bfe8bc9636cbfb77ffb5cd045c782baa994c8db00"
    sha256 cellar: :any,                 arm64_big_sur:  "f7529c0daad5e67382365fc6579d0d9e97f387872e01c7efafc72d0407777b73"
    sha256 cellar: :any,                 monterey:       "dce5b4236e826b3366ad4e7f7e3b247e308e4d2d8e30f9af76f2694be8f5bff8"
    sha256 cellar: :any,                 big_sur:        "52540c517e787ff0a373e08757bf3355bcc8505cac93eb8a0d332bc08115505f"
    sha256 cellar: :any,                 catalina:       "cb97d57708f7419dc1fd08d744e4de12e9a0ab1203b15ad1f8bc0b8c81aae91d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "46084a7ef5a36aa3322a5ac724092fd864fa4695a55e82d254304702e48a5de0"
  end

  depends_on "cmake" => :build
  depends_on "python@3.10" => :build

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"

    pkgshare.install "test/"
  end

  test do
    system "#{bin}/wasm-opt", "-O", "#{pkgshare}/test/passes/O1_print-stack-ir.wast", "-o", "1.wast"
    assert_match "stacky-help", File.read("1.wast")
  end
end
