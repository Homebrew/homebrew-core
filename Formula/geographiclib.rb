class Geographiclib < Formula
  desc "C++ geography library"
  homepage "https://geographiclib.sourceforge.io/"
  url "https://github.com/geographiclib/geographiclib/archive/refs/tags/r2.2.tar.gz"
  sha256 "6611507210baf1827259f50ac970ab2e8c57a772f7c90ede4829f8834fd3d934"
  license "MIT"
  head "https://github.com/geographiclib/geographiclib.git", branch: "main"

  livecheck do
    url :stable
    regex(/^r(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d3af59a982fb0fa2f335a31dae74bc7b6edf4b8a54dd678018fcf4e1e8b60180"
    sha256 cellar: :any,                 arm64_monterey: "00ffe52a19790b22caa22a1b8ddb4fe0f98005994893d0b83cd9f9d614695e00"
    sha256 cellar: :any,                 arm64_big_sur:  "f45f2076d3f4abfd6d824ed97ee4fc1dc8caba81890b8029e41c1f9c9a075882"
    sha256 cellar: :any,                 ventura:        "994095d46559b93a47d531b9db13de51a88e99e873a6b867cde833091d508a94"
    sha256 cellar: :any,                 monterey:       "c66f9146360b2e7f16bdbed3a9307e2281745a21e06fc38cc1f2c8f856d0082d"
    sha256 cellar: :any,                 big_sur:        "cf5e40e907f037c90a065d3c487caf0409707211f268ac314e02883f287642d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69d905b53ed94ccb162274756388b4f73fc6bdd7431560cc967590d93c9bacd2"
  end

  depends_on "cmake" => :build

  def install
    args = ["-DEXAMPLEDIR="]
    args << "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}" if OS.mac?
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"GeoConvert", "-p", "-3", "-m", "--input-string", "33.3 44.4"
  end
end
