class Cfitsio < Formula
  desc "C access to FITS data files with optional Fortran wrappers"
  homepage "https://heasarc.gsfc.nasa.gov/docs/software/fitsio/fitsio.html"
  url "https://heasarc.gsfc.nasa.gov/FTP/software/fitsio/c/cfitsio-4.6.3.tar.gz"
  sha256 "fad44fff274fdda5ffcc0c0fff3bc3c596362722b9292fc8944db91187813600"
  license "CFITSIO"
  revision 1

  livecheck do
    url :homepage
    regex(/href=.*?cfitsio[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "918983cfb5da385c576dd824d187fe8ee240a7c1516a36bff814101dadb16a3b"
    sha256 cellar: :any,                 arm64_sequoia: "b941d8b944e1f39a29dcf96f4eb5b0c52fe6a9752f681f8c0daa5f6e4d2b150d"
    sha256 cellar: :any,                 arm64_sonoma:  "b7d90f791bb15c90eba273f60f4b9ebf26f32f75c779ec34a3e39344dff46a5c"
    sha256 cellar: :any,                 sonoma:        "52fcd05eb4da45db0a5f3538d731af42b5c1936d3a42a4da19e759d8db608ffc"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4a8be3014dd22ae6e593c46523fb2b02ec2015cc0cb8583cc1500921b2e56758"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cb23f4fd808a941684ba54c17eee5a6e3bc5b3a07fa9691a065f4c5df419bcee"
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
