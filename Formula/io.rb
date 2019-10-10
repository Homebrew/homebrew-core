class Io < Formula
  desc "Small prototype-based programming language"
  homepage "http://iolanguage.com/"
  url "https://github.com/stevedekorte/io/archive/2017.09.06.tar.gz"
  sha256 "9ac5cd94bbca65c989cd254be58a3a716f4e4f16480f0dc81070457aa353c217"
  head "https://github.com/stevedekorte/io.git"

  bottle do
    sha256 "1dc9783722f9ea256f7f0dcb57032dee40692a78a31707eca025b52c8857772c" => :catalina
    sha256 "9e628fa0879d7d2e370ae5275393d1d52b578f6f10d3f005faf9d0360caf8851" => :mojave
    sha256 "686d5d23790b53c27765d49da0a74ec96ee949353b31646a0a92ee931270a23d" => :high_sierra
    sha256 "2d0e05344917ad3a1d322f2860030013315ceb7e8ae962cf6070d1ee8cc395d4" => :sierra
    sha256 "3a5a0e9a1ec0ce7f4bc6bcfc5fb8c782f0b1ba0451251aaab51a796452b59e67" => :el_capitan
    sha256 "16d31a7062e2c7ebab815bcd48b03aab9597a6c40071cb407e2bc6dec91fef0b" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  uses_from_macos "libxml2"

  def install
    ENV.deparallelize

    # FSF GCC needs this to build the ObjC bridge
    ENV.append_to_cflags "-fobjc-exceptions"

    # Turn off all add-ons in main cmake file
    inreplace "CMakeLists.txt", "add_subdirectory(addons)",
                                "#add_subdirectory(addons)"

    mkdir "buildroot" do
      system "cmake", "..", "-DCMAKE_DISABLE_FIND_PACKAGE_ODE=ON",
                            "-DCMAKE_DISABLE_FIND_PACKAGE_Theora=ON",
                            *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.io").write <<~EOS
      "it works!" println
    EOS

    assert_equal "it works!\n", shell_output("#{bin}/io test.io")
  end
end
