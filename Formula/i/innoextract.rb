class Innoextract < Formula
  desc "Tool to unpack installers created by Inno Setup"
  homepage "https://constexpr.org/innoextract/"
  url "https://constexpr.org/innoextract/files/innoextract-1.9.tar.gz"
  sha256 "6344a69fc1ed847d4ed3e272e0da5998948c6b828cb7af39c6321aba6cf88126"
  license "Zlib"
  revision 10
  head "https://github.com/dscharrer/innoextract.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?innoextract[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "653948d44a91bfc4b452db5ff09f022967bee5fb6fcf2b9368e9d7b2ca61d676"
    sha256 cellar: :any,                 arm64_sonoma:  "5658b594392eabdf27cb01b08b8c70d0ad4d415e8df226c7a851f026b96db2ff"
    sha256 cellar: :any,                 arm64_ventura: "9d5d41064e579dc82059762171e6d11be09e09de1a04f2d14cc9f714c8b8e0d0"
    sha256 cellar: :any,                 sonoma:        "ebf2344eeb9e6be6f8cf2cdcdd7ae9226d4500c63f1e18aeb32fdb20655b11f8"
    sha256 cellar: :any,                 ventura:       "0b6bc1f911b58b61398f21afd839843cdd1502d2728f0e906d79dd5b74398f3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "494cfd4d754e4eecf0b7b7d2097878fb2cfb3d3a45567f286ef79527b77cc37c"
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
