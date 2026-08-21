class Innoextract < Formula
  desc "Tool to unpack installers created by Inno Setup"
  homepage "https://constexpr.org/innoextract/"
  license "Zlib"
  revision 14
  head "https://github.com/dscharrer/innoextract.git", branch: "master"

  stable do
    url "https://constexpr.org/innoextract/files/innoextract-1.9.tar.gz"
    sha256 "6344a69fc1ed847d4ed3e272e0da5998948c6b828cb7af39c6321aba6cf88126"

    # Backport commit to fix build with CMake 4
    patch do
      url "https://github.com/dscharrer/innoextract/commit/83d0bf4365b09ddd17dddb400ba5d262ddf16fb8.patch?full_index=1"
      sha256 "fe5299d1fdea5c66287aef2f70fee41d86aedc460c5b165da621d699353db07d"
      type :backport
    end

    # Fix build with `boost` 1.85.0 using merged, unreleased PR
    # PR ref: https://github.com/dscharrer/innoextract/pull/169
    patch do
      url "https://github.com/dscharrer/innoextract/commit/264c2fe6b84f90f6290c670e5f676660ec7b2387.patch?full_index=1"
      sha256 "f968a9c0521083dd4076ce5eed56127099a9c9888113fc50f476b914396045cc"
      type :backport
      resolves "https://github.com/dscharrer/innoextract/pull/169"
    end
  end

  livecheck do
    url :homepage
    regex(/href=.*?innoextract[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "1da3c10fc5c1a8f061e9416279c26ce59d0bd8f5d46a1ca7081a0d958e69f6b4"
    sha256 cellar: :any, arm64_sequoia: "5365fa60d73761684e6dfec465542cd2f36563e3753bf99bda2c209fd46c3f25"
    sha256 cellar: :any, arm64_sonoma:  "9f8a39c109afe223626ba99ee2fb50362ccc999325cf1fa2835afc720b0a7338"
    sha256 cellar: :any, sonoma:        "26bdfa048bcb7acec125efa29e7da88f1dccd0d47387621eb93e923a356f86ad"
    sha256 cellar: :any, arm64_linux:   "8db38f19c0ae4adf9deb9a3c831857b90144331f8baf3bf409cabb9417c2987f"
    sha256 cellar: :any, x86_64_linux:  "cc9a7777af293272e353d830b61c9cdb27d635eaf28818774840db28f2dd3f14"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "xz"

  # Fix build with `boost` 1.89.0 using open PR
  patch do
    url "https://github.com/dscharrer/innoextract/commit/882796e0e9b134b02deeaae4bbfe92920adb6fe2.patch?full_index=1"
    sha256 "d5af3e86eb2b74bff559885440d330678e5dbb028ce165bb836ddb14224af201"
    type :unofficial
    resolves "https://github.com/dscharrer/innoextract/pull/199"
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
