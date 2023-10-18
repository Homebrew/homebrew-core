class Keystone < Formula
  desc "Assembler framework: Core + bindings"
  homepage "https://www.keystone-engine.org/"
  url "https://github.com/keystone-engine/keystone/archive/0.9.2.tar.gz"
  sha256 "c9b3a343ed3e05ee168d29daf89820aff9effb2c74c6803c2d9e21d55b5b7c24"
  license "GPL-2.0"
  head "https://github.com/keystone-engine/keystone.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4a92886bc77c62627e87ee2cf8023ca369c3592c79873e3f993b299cb50d219a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41e04237bdb7b026db2bfdff26829a6c6ecba95b6b23ee496c3b0cc6d374e22c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cbb19b4292aa9bdeca592d7d775423bb8a9f9c1547199e205659fdb8f653e0bc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f504af4a278854b6a67b72d1f4eac96c2966cdcaf81b36aee6fd72aa6ac25e2d"
    sha256 cellar: :any_skip_relocation, sonoma:         "919544ac6be497ff3b27d5d531a28ab89d83a379e1968d8bce973f2939823f49"
    sha256 cellar: :any_skip_relocation, ventura:        "3ca2d31e7f57a69792e963c4bd09a0eaa5a4b70bfa3faffe9fe5832139e1be4b"
    sha256 cellar: :any_skip_relocation, monterey:       "97781c17cfa261a887cb9f38e5f89f52917e289e812b63c131e0c036dce5facb"
    sha256 cellar: :any_skip_relocation, big_sur:        "060a77b372c27c2084589b99408ff19b3d0254a3aafe3f98bd33e25c031065cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e353d535d1cf5700d78bf12b09ed1d462a7e4d3d4349eed1b38cb3fcbdad8105"
  end

  depends_on "cmake" => :build
  depends_on "python@3.12" => :build

  def python
    which("python3.12")
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DPYTHON_EXECUTABLE=#{python}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_equal "nop = [ 90 ]", shell_output("#{bin}/kstool x16 nop").strip
  end
end
