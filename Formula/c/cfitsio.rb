class Cfitsio < Formula
  desc "C access to FITS data files with optional Fortran wrappers"
  homepage "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
  url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio-4.6.3.tar.gz"
  sha256 "fad44fff274fdda5ffcc0c0fff3bc3c596362722b9292fc8944db91187813600"
  license "CFITSIO"

  livecheck do
    url :homepage
    regex(/href=.*?cfitsio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "f1f544bfb17b7c775fb0d6e0ef066776eef812632068d0a907e38c3bb8112da0"
    sha256 cellar: :any,                 arm64_sequoia: "4740877f5ef82d5de96cd115c90726d69cbb6bdbf173e658455a478014980d14"
    sha256 cellar: :any,                 arm64_sonoma:  "4dc73f475934e5f188eefc117f64ad8ef0eac412b3b0aa65901156594b145334"
    sha256 cellar: :any,                 sonoma:        "58d81f8c8d8af06c7ce37007789748cdfa283c2d3ef63d6dc3d217d32c295688"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3250dc2bc7f30d60e50d4739d6cce788e91afc5a0f3a350d8412eeea7fbf1fb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ff756bf08e864fbe6416cbe1513a6a88d4c377fa63188a0e2f9c87cbb1ce3ff"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test
  uses_from_macos "zlib"

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
