class Keystone < Formula
  desc "Assembler framework: Core + bindings"
  homepage "https://www.keystone-engine.org/"
  url "https://github.com/keystone-engine/keystone/archive/0.9.2.tar.gz"
  sha256 "c9b3a343ed3e05ee168d29daf89820aff9effb2c74c6803c2d9e21d55b5b7c24"
  license "GPL-2.0"
  head "https://github.com/keystone-engine/keystone.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "84cdef2aa8a5697ce2fc62e6ae1316f2dcca6fcd0f92d2bba68b399af9c48440" => :catalina
    sha256 "814feeee85e111a21fdd287fbed3fca3e1cd86be396dcba7612c3e1aec7dd4d3" => :mojave
    sha256 "77740af9b9e48baaf0a7d1dc4d74b883c1babbaab6a7e9bf65a00035b59c546d" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_equal "nop = [ 90 ]", shell_output("#{bin}/kstool x16 nop").strip
  end
end
