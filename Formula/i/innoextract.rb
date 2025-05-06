class Innoextract < Formula
  desc "Tool to unpack installers created by Inno Setup"
  homepage "https://constexpr.org/innoextract/"
  license "Zlib"
  revision 11
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

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a6ecba6f9571ac08021cee5007d4ce46bc1c8af96f996dd58397fe2f2466d9c7"
    sha256 cellar: :any,                 arm64_sonoma:  "8bcb1acc92f2b71ba74dbd9989858cb4c97c673ea4165d9a917005e3ae20ee0d"
    sha256 cellar: :any,                 arm64_ventura: "078863c79c61eaa1bf3b34960334582c52c8cf6932d279f460fce2718a6ee852"
    sha256 cellar: :any,                 sonoma:        "13374c0149963a68d215be71fee1e3be6ad3bc94793b582ec0545fc850a6186b"
    sha256 cellar: :any,                 ventura:       "2d06f2828524c9790714130e550fe7aad4b157005b39652633500dbe35aaacb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1a14135ee0ef9142fd550768cf198305ba67081514b03fe6ff1c36c3b0e1247b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f307fcdedb067bd399862b2640f25a92c31cd1ce5ab6d00ab113bfcb6a88f62d"
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
