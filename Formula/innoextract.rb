class Innoextract < Formula
  desc "Tool to unpack installers created by Inno Setup"
  homepage "https://constexpr.org/innoextract/"
  url "https://constexpr.org/innoextract/files/innoextract-1.9.tar.gz"
  sha256 "6344a69fc1ed847d4ed3e272e0da5998948c6b828cb7af39c6321aba6cf88126"
  license "Zlib"
  revision 1
  head "https://github.com/dscharrer/innoextract.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?innoextract[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8d3c333b0f91323d054686301631c0a05dd7dd86043f381391c5fcf610d4a6dd"
    sha256 cellar: :any,                 arm64_big_sur:  "1ae6aa03dc3ce7eeb8fbab79a58152f64ea662c241209adba2ef1459e6bbe6b7"
    sha256 cellar: :any,                 monterey:       "7206f8b88483356746d682b1e631d214e6172b808bd7b8b0567cb9c0f0906abb"
    sha256 cellar: :any,                 big_sur:        "cf14268447df754abb74356d322fba5d79498a5f4c84712dd025f6deb569d6bc"
    sha256 cellar: :any,                 catalina:       "86e50d088f0fd4cc1e4827d311f7f2747ee6768ebffc45c23db652ab2154f0e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a50fce1d709021b5cc8f2e004e2a0b61544235b0354193b7e1ea38c7c6c5f15"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "xz"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/innoextract", "--version"
  end
end
