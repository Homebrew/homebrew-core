class Keystone < Formula
  desc "Assembler framework: Core + bindings"
  homepage "https://www.keystone-engine.org/"
  url "https://github.com/keystone-engine/keystone/archive/0.9.2.tar.gz"
  sha256 "c9b3a343ed3e05ee168d29daf89820aff9effb2c74c6803c2d9e21d55b5b7c24"
  head "https://github.com/keystone-engine/keystone.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "75683abbb09ac9e29703e7ce788a86e010a53fea0437fe5c531f75efbc10a048" => :catalina
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
