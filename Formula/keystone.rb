class Keystone < Formula
  desc "Assembler framework: Core + bindings"
  homepage "http://www.keystone-engine.org"
  url "https://github.com/keystone-engine/keystone/archive/0.9.1.tar.gz"
  sha256 "e9d706cd0c19c49a6524b77db8158449b9c434b415fbf94a073968b68cf8a9f0"
  head "https://github.com/keystone-engine/keystone.git"

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_equal "nop = [ 90 ]", shell_output("#{bin}/kstool x16 nop").strip
  end
end
