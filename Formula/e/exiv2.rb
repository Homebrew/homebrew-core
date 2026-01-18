class Exiv2 < Formula
  desc "EXIF and IPTC metadata manipulation library and tools"
  homepage "https://exiv2.org/"
  url "https://github.com/Exiv2/exiv2/archive/refs/tags/v0.28.7.tar.gz"
  sha256 "5e292b02614dbc0cee40fe1116db2f42f63ef6b2ba430c77b614e17b8d61a638"
  license "GPL-2.0-or-later"
  head "https://github.com/Exiv2/exiv2.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3bd7cd0e83a6162d4358f2e36fd7107caf401a762f69afaebd419c7cb5e91df1"
    sha256 cellar: :any,                 arm64_sequoia: "786c1c6814e9a66bd529beab979c4561325f5e0ea86174a606c4d00df43bc683"
    sha256 cellar: :any,                 arm64_sonoma:  "169a123782431874518ab22cb1cbdc24e2404f4c3d3baf3ebaface5225c91d12"
    sha256 cellar: :any,                 arm64_ventura: "71a967bd20ea65f3520eb896c1cc6fbc66827d3e9bfa6f2636cc3c51e7de80bc"
    sha256 cellar: :any,                 sonoma:        "436dd0a3b4727b40598837678d33447daa24953925c5d1993df87f9f449d6134"
    sha256 cellar: :any,                 ventura:       "78647feacc19846fac0a776338881ccc42700601983079e0b177666c9799b591"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47f02134c7bd42aac15f5de799fdfe664a2921236f7652b7ab2302335ca558ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "002658250128994bda7ec81297130a268c86c01c465182794ee6faace4c629e8"
  end

  depends_on "cmake" => :build
  depends_on "brotli"
  depends_on "inih"
  depends_on "libssh"

  uses_from_macos "curl"
  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "gettext" => :build # for msgmerge
  end

  def install
    args = %W[
      -DEXIV2_ENABLE_XMP=ON
      -DEXIV2_ENABLE_VIDEO=ON
      -DEXIV2_ENABLE_PNG=ON
      -DEXIV2_ENABLE_NLS=ON
      -DEXIV2_ENABLE_PRINTUCS2=ON
      -DEXIV2_ENABLE_LENSDATA=ON
      -DEXIV2_ENABLE_VIDEO=ON
      -DEXIV2_ENABLE_WEBREADY=ON
      -DEXIV2_ENABLE_CURL=ON
      -DEXIV2_ENABLE_SSH=ON
      -DEXIV2_ENABLE_BMFF=ON
      -DEXIV2_BUILD_SAMPLES=OFF
      -DSSH_LIBRARY=#{Formula["libssh"].opt_lib}/#{shared_library("libssh")}
      -DSSH_INCLUDE_DIR=#{Formula["libssh"].opt_include}
      -DCMAKE_INSTALL_NAME_DIR:STRING=#{lib}
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match "288 Bytes", shell_output("#{bin}/exiv2 #{test_fixtures("test.jpg")}", 253)
  end
end
