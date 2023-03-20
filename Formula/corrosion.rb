class Corrosion < Formula
  desc "Easy Rust and C/C++ Integration"
  homepage "https://github.com/corrosion-rs/corrosion"
  url "https://github.com/corrosion-rs/corrosion/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "3cee986d4a99fd965d70c96f6640eeff9723cc2815d367b22624ace53f3fd47a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "51ed5d6f914c28fbd4bdfaa557f67c050ca98e13c8de32353c943f1d2215fa9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5e2269d23682b87112f8ceda5dbc0659961a659b19b0c7fdda54262e24f72f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57a9ab2f8ef59b8bcf23f24db9b04b70287314acee8f07aa287a5af0ac7c810b"
    sha256 cellar: :any_skip_relocation, ventura:        "eb6853b5cf2d6680f0875a165a83b065a9b69abbecbb8853ad1c3a6f45a833bf"
    sha256 cellar: :any_skip_relocation, monterey:       "53862b339521e9686001d04803e1ad2fc7e4a3eb128daab08342526f2a1e45e4"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6a0dbdf01e8fdf5d321af03e8e73b90e899b4fb30fe6fe3c973c707e67378a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0bfeaa2e85cd3e7995cf81b007db29295f2a28471d6028ffc757c06e4d00e639"
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
