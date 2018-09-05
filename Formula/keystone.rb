class Keystone < Formula
  desc "Assembler framework: Core + bindings"
  homepage "https://www.keystone-engine.org/"
  url "https://github.com/keystone-engine/keystone/archive/0.9.1.tar.gz"
  sha256 "e9d706cd0c19c49a6524b77db8158449b9c434b415fbf94a073968b68cf8a9f0"
  head "https://github.com/keystone-engine/keystone.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c914d5799915bc7c40fa1e82a407d8e40dcc583c904a3da24042b1a4abdeb5bc" => :mojave
    sha256 "bb281d9882f991ce15f0c7c421af9af9ed7f9ac1d563bc6bbe5ff7ce5352617d" => :high_sierra
    sha256 "b6cd1a7208fa16627366dfa4ba297edbf1dba6baf01a031d830b292e0e6cd019" => :sierra
    sha256 "25a45e702238530539973a7a28ffdfe5aa512be3cd639b3247895d11d6f9576f" => :el_capitan
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
