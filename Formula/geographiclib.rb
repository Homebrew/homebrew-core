class Geographiclib < Formula
  desc "C++ geography library"
  homepage "https://geographiclib.sourceforge.io/"
  url "https://github.com/geographiclib/geographiclib/archive/refs/tags/r2.2.tar.gz"
  sha256 "6611507210baf1827259f50ac970ab2e8c57a772f7c90ede4829f8834fd3d934"
  license "MIT"
  head "https://github.com/geographiclib/geographiclib.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "8fe27a4ff40ba356a6051c12de9be885e0975f650470112cd2fd866c73ccac70"
    sha256 cellar: :any,                 arm64_monterey: "0656460a081194749f8145ec92a301341a98bf744f49c10f80c585943817aa98"
    sha256 cellar: :any,                 arm64_big_sur:  "e15443f94e1ef88f0ce67a9c8e3e63d6e5e26e56376c8e26edd8e0552cfdc111"
    sha256 cellar: :any,                 ventura:        "39603727354eb99973d9e6c5e9c15befb255448fde85f764a837f4dccf391f63"
    sha256 cellar: :any,                 monterey:       "96bfea5ee3d69286edd6b92db4f8f211aae8fc02ddf5bfa333379125f085ab28"
    sha256 cellar: :any,                 big_sur:        "8ad28b466412f738bccf88be96aa4f167d771d3f06379f59b7aeb427f6a10fc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f18b550bc3afdc667b4a2282e84f603d278d9c957b6ccdd45b032c05162427a"
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
