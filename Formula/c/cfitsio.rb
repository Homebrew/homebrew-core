class Cfitsio < Formula
  desc "C access to FITS data files with optional Fortran wrappers"
  homepage "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
  url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio-4.6.4.tar.gz"
  sha256 "227b637b91c9820ea96f39a65eb087f053de567d82f4338e2884f123f8183c55"
  license "CFITSIO"
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?cfitsio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2353b2536db332cdc37dd7f6c3003957dc9a789388ce6118446c0c4532d0bab3"
    sha256 cellar: :any,                 arm64_sequoia: "308d9e0e397167131881e0807bde8246bbc542a908a8f02fcf344dcee0cf405e"
    sha256 cellar: :any,                 arm64_sonoma:  "44c5ef7f5f03f2f10a7d42dc33acd47c86774d5e908ea1adda10ecf8dc4c7b1a"
    sha256 cellar: :any,                 sonoma:        "e724865bb3af65038616b13c45763c771bff50b34b39439904a11acb359affd0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "df79bedd066ce570fcab74bae86faee9767480c903c51c897a8464f42f3d3a31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e9378185a54e7322582fa554444b3d324da60aac3b4e0f95a4cd0e2ee62bf65e"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    # Incorporates upstream commits:
    #   https://github.com/HEASARC/cfitsio/commit/8ea4846049ba89e5ace4cc03d7118e8b86490a7e
    #   https://github.com/HEASARC/cfitsio/commit/6aee9403917f8564d733938a6baa21b9695da442
    # Review for removal in next release
    inreplace "cfitsio.pc.cmake" do |f|
      f.sub!(/exec_prefix=.*/, "exec_prefix=${prefix}")
      f.sub!(/libdir=.*/, "libdir=${exec_prefix}/@CMAKE_INSTALL_LIBDIR@")
      f.sub!(/includedir=.*/, "includedir=${prefix}/@CMAKE_INSTALL_INCLUDEDIR@")
    end

    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_INSTALL_INCLUDEDIR=include
      -DUSE_PTHREADS=ON
      -DTESTS=OFF
    ]
    # Workaround to build with CMake 4
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    (pkgshare/"testprog").install Dir["testprog*", "utilities/testprog.c"]
  end

  test do
    cp Dir["#{pkgshare}/testprog/testprog*"], testpath
    flags = shell_output("pkg-config --cflags --libs #{name}").split
    system ENV.cc, "testprog.c", "-o", "testprog", *flags
    system "./testprog > testprog.lis"
    cmp "testprog.lis", "testprog.out"
    cmp "testprog.fit", "testprog.std"
  end
end
