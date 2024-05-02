class Innoextract < Formula
  desc "Tool to unpack installers created by Inno Setup"
  homepage "https://constexpr.org/innoextract/"
  url "https://constexpr.org/innoextract/files/innoextract-1.9.tar.gz"
  sha256 "6344a69fc1ed847d4ed3e272e0da5998948c6b828cb7af39c6321aba6cf88126"
  license "Zlib"
  revision 8
  head "https://github.com/dscharrer/innoextract.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?innoextract[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9f2ca2ec92ed901109a7b6e58a76ee317d005789802a99c1eac42cf864a123b5"
    sha256 cellar: :any,                 arm64_ventura:  "d92956e6f247321985b2e5ab306dc982679dbe753f1064bdf855613818025c84"
    sha256 cellar: :any,                 arm64_monterey: "aa0796b56c364212a2acaaf00e88a895aa28b3f1b27e1df0031351058c2ed472"
    sha256 cellar: :any,                 sonoma:         "6bd4b35fbab4381c5c4641aea04c3a9c6d05a18ba437904b486336c58321a1a2"
    sha256 cellar: :any,                 ventura:        "fb354b7b22cc5c586c135ab1db0a7801c3212881d7057990e9b0ce72bf4f608b"
    sha256 cellar: :any,                 monterey:       "a0106888f740f7da1b967f9e841b305fe377048185c092621b11ce9db3cdb54b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "842ce66d5a1cc8187b9dc53482b7811b633bad34df863b7480ad42bccd3942da"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "xz"

  # Fix build with `boost` 1.85.0 using open PR
  # PR ref: https://github.com/dscharrer/innoextract/pull/169
  patch do
    url "https://github.com/dscharrer/innoextract/commit/264c2fe6b84f90f6290c670e5f676660ec7b2387.patch?full_index=1"
    sha256 "f968a9c0521083dd4076ce5eed56127099a9c9888113fc50f476b914396045cc"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/innoextract", "--version"
  end
end
