class Flvmeta < Formula
  desc "Manipulate Adobe flash video files (FLV)"
  homepage "https://www.flvmeta.com/"
  url "https://flvmeta.com/files/flvmeta-1.2.2.tar.gz"
  sha256 "a51a2f18d97dfa1d09729546ce9ac690569b4ce6f738a75363113d990c0e5118"
  head "https://github.com/noirotm/flvmeta.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "bb16f5006d22ffaebba50c0d9c5cc962cf73dfcf1ca51d1e69735908ef9aa8cd" => :catalina
    sha256 "176a5edcfbe2da366e27f67590c45870b59ad250cc7f2a51d7a8d0a18f12632b" => :mojave
    sha256 "2ef376486588157dc4e17914ab8ba62a1689aaf92fe101613f93fd0d05018fee" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system bin/"flvmeta", "-V"
  end
end
