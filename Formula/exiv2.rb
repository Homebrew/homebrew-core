class Exiv2 < Formula
  desc "EXIF and IPTC metadata manipulation library and tools"
  homepage "http://www.exiv2.org"
  url "http://www.exiv2.org/builds/exiv2-0.26-trunk.tar.gz"
  sha256 "c75e3c4a0811bf700d92c82319373b7a825a2331c12b8b37d41eb58e4f18eafb"

  bottle do
    cellar :any
    sha256 "dd61b9fd3d581b1161720c403426be20c45372b11abcd756857d1c5d0f33d1c2" => :sierra
    sha256 "18c178d4658053e2c27bff51485bb61b5d8389d7fd516776ac287f2bd44e40dc" => :el_capitan
    sha256 "57f9c08d37d0d2b7286a6a3cb0223bda1d3d33d8a3fb036f93aa520a6f9f3488" => :yosemite
  end

  head do
    url "svn://dev.exiv2.org/svn/trunk"
    depends_on "cmake" => :build
    depends_on "gettext" => :build
    depends_on "libssh"
  end

  def install
    if build.head?
      args = std_cmake_args
      args += %W[
        -DEXIV2_ENABLE_SHARED=ON
        -DEXIV2_ENABLE_XMP=ON
        -DEXIV2_ENABLE_LIBXMP=ON
        -DEXIV2_ENABLE_VIDEO=ON
        -DEXIV2_ENABLE_PNG=ON
        -DEXIV2_ENABLE_NLS=ON
        -DEXIV2_ENABLE_PRINTUCS2=ON
        -DEXIV2_ENABLE_LENSDATA=ON
        -DEXIV2_ENABLE_COMMERCIAL=OFF
        -DEXIV2_ENABLE_BUILD_SAMPLES=ON
        -DEXIV2_ENABLE_BUILD_PO=ON
        -DEXIV2_ENABLE_VIDEO=ON
        -DEXIV2_ENABLE_WEBREADY=ON
        -DEXIV2_ENABLE_CURL=ON
        -DEXIV2_ENABLE_SSH=ON
        -DSSH_LIBRARY=#{Formula["libssh"].opt_lib}/libssh.dylib
        -DSSH_INCLUDE_DIR=#{Formula["libssh"].opt_include}
        ..
      ]
      mkdir "build.cmake" do
        system "cmake", "-G", "Unix Makefiles", ".", *args
        system "make", "install"
        # `-DCMAKE_INSTALL_MANDIR=#{man}` doesn't work
        mv prefix/"man", man
      end
    else
      system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
      system "make", "install"
    end
  end

  test do
    assert_match "288 Bytes", shell_output("#{bin}/exiv2 #{test_fixtures("test.jpg")}", 253)
  end
end
