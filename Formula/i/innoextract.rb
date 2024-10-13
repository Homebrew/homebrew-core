class Innoextract < Formula
  desc "Tool to unpack installers created by Inno Setup"
  homepage "https://constexpr.org/innoextract/"
  url "https://constexpr.org/innoextract/files/innoextract-1.9.tar.gz"
  sha256 "6344a69fc1ed847d4ed3e272e0da5998948c6b828cb7af39c6321aba6cf88126"
  license "Zlib"
  revision 9
  head "https://github.com/dscharrer/innoextract.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?innoextract[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "bdb79b724eb71b85cacb7911da0fc14d442b8b668162c8745b4e6257df495c28"
    sha256 cellar: :any,                 arm64_sonoma:   "2d60ed6571f7d230035575cfe3630f7b2b7243bd911f69313dad3f981257fca6"
    sha256 cellar: :any,                 arm64_ventura:  "19c8b7a38bd209c865695899c1cbb894569756751e22706a500a97598552dc77"
    sha256 cellar: :any,                 arm64_monterey: "377142c8b5f00721c84f3a00157b7b26f270cbb3026da05f504f34f3bec80506"
    sha256 cellar: :any,                 sonoma:         "c5a9bddd53d55669ac2203d86bae7f7feb864fd63bfd47f79e79885337cf10cf"
    sha256 cellar: :any,                 ventura:        "8369c9af2fbd6cd7243b7d193e24d5402580537d0649738c67bc76ec8905d723"
    sha256 cellar: :any,                 monterey:       "75e199d52822c846a48beab97ee091b028ccd757c0dc4abc25cd857e6bd29958"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4492c1d8f175a20dbeaefca61a2c0d3525750c9939b210dff39fd6a123e1b439"
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
    system bin/"innoextract", "--version"
  end
end
