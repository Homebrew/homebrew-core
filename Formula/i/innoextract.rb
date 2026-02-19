class Innoextract < Formula
  desc "Tool to unpack installers created by Inno Setup"
  homepage "https://constexpr.org/innoextract/"
  license "Zlib"
  revision 13
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
    sha256 cellar: :any,                 arm64_tahoe:   "1150222eb02fdb776418d3253e62ba75592481225b162026bf45ad687784d730"
    sha256 cellar: :any,                 arm64_sequoia: "9231e79c53ec988162f3173dad48d1e9a3d104af8b21e10f6837c922d4d12d99"
    sha256 cellar: :any,                 arm64_sonoma:  "6ce904e75b4a103173837ba1c26d8b595d66123fbf5550a53ec83ff6b9bedc66"
    sha256 cellar: :any,                 sonoma:        "eccddde976f66e9cddc35f6f72cac7c2377312343bb8cdfb954797c3173ead17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "54d89c53d511089ab43432dc90c8cf8acc3ea5c3bb5ddf0f01f1954bcd9ec4ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4fcfb3e634def1947791fab8be9c9b2ede7a6c453de29d92491a35638090afee"
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
