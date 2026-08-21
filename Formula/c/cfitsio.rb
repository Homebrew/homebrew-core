class Cfitsio < Formula
  desc "C access to FITS data files with optional Fortran wrappers"
  homepage "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
  url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio-4.7.0.tar.gz"
  sha256 "ce573bbea8e75b429f8c3d3e86498741ba3dc9628a1530d2f65268397ad059e8"
  license "CFITSIO"
  compatibility_version 1

  livecheck do
    url :homepage
    regex(/href=.*?cfitsio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f9b46bf80fc9722d2b6fcc4f06ade7a3bb8a3862509fd65c62aa9b0d87b44d13"
    sha256 cellar: :any, arm64_sequoia: "69d71ee19fc9d2b498adbf462dbc57356854839f5911eecfccdb328105e26b9f"
    sha256 cellar: :any, arm64_sonoma:  "86813032566ed2d9b4ef2b7c0af87b3083c10ce5366e7dbfcfc787a3cc8e700c"
    sha256 cellar: :any, sonoma:        "16154d55f8f92bd5218f8223783ef4393a3ac01348635e76b17a6710f07563d4"
    sha256 cellar: :any, arm64_linux:   "0de463b105296c11b1f3b66c6dfbcc3dc92d647f1acd123ea5040601416c5cf2"
    sha256 cellar: :any, x86_64_linux:  "c2dd6ba3300813af4122055ff521728a3407d5a93bb07d307c5287088476af3f"
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
