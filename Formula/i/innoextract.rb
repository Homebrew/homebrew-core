class Innoextract < Formula
  desc "Tool to unpack installers created by Inno Setup"
  homepage "https://constexpr.org/innoextract/"
  license "Zlib"
  revision 12
  head "https://github.com/dscharrer/innoextract.git", branch: "master"

  stable do
    url "https://constexpr.org/innoextract/files/innoextract-1.9.tar.gz"
    sha256 "6344a69fc1ed847d4ed3e272e0da5998948c6b828cb7af39c6321aba6cf88126"

    # Backport commit to fix build with CMake 4
    patch do
      url "https://github.com/dscharrer/innoextract/commit/83d0bf4365b09ddd17dddb400ba5d262ddf16fb8.patch?full_index=1"
      sha256 "fe5299d1fdea5c66287aef2f70fee41d86aedc460c5b165da621d699353db07d"
    end
  end

  livecheck do
    url :homepage
    regex(/href=.*?innoextract[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "df1001d2198270418a0af98f0280a10be338dc2dcbfc7b0c8adcc96d2d813309"
    sha256 cellar: :any,                 arm64_sequoia: "f058c122e886a8f35997bc3603c10f791ad3a7eb9d0cd084aa081babf7833743"
    sha256 cellar: :any,                 arm64_sonoma:  "e65c6340749c752ab228536d9ed8323e77a18132a6578eaa7d86950d07628f0a"
    sha256 cellar: :any,                 arm64_ventura: "aa58225a507ab5162d5744d0ad7845ad4a444ef8e6680d75ed52a19b8b019876"
    sha256 cellar: :any,                 sonoma:        "90ee4acae6795def50a0a74c8330aeff551818734c8351463f10a6b584a565e2"
    sha256 cellar: :any,                 ventura:       "48c724ab7793c79e6fed6777c86cc0c971c1b4ac1613e0a39ef471196f7bcacc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5ccafaae9f5a27b4a20a388c818e8de1a65e29ddc5c6ab3f5f7fd8664dee0d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "823a6cad250181cac9e656165b82633b0c7e9d0e7f5baecd73f9630eae2fd5b1"
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

  # Fix build with `boost` 1.89.0 using open PR
  # PR ref: https://github.com/dscharrer/innoextract/pull/199
  patch do
    url "https://github.com/dscharrer/innoextract/commit/882796e0e9b134b02deeaae4bbfe92920adb6fe2.patch?full_index=1"
    sha256 "d5af3e86eb2b74bff559885440d330678e5dbb028ce165bb836ddb14224af201"
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
