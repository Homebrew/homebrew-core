class Airspyhf < Formula
  desc "Driver and tools for a software-defined radio"
  homepage "https://airspy.com/"
  url "https://github.com/airspy/airspyhf/archive/1.6.8.tar.gz"
  sha256 "cd1e5ae89e09b813b096ae4a328e352c9432a582e03fd7da86760ba60efa77ab"
  license "BSD-3-Clause"
  head "https://github.com/airspy/airspyhf.git", branch: "master"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    args = std_cmake_args

    libusb = Formula["libusb"]
    args << "-DLIBUSB_INCLUDE_DIR=#{libusb.opt_include}/libusb-#{libusb.version.major_minor}"
    args << "-DLIBUSB_LIBRARIES=#{libusb.opt_lib/shared_library("libusb-#{libusb.version.major_minor}")}"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libairspyhf/airspyhf.h>
      int main()
      {
        uint64_t serials[256];
        int n = airspyhf_list_devices(serials, 256);
        if (n == 0)
        {
          return 0;
        }
        return 1;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lairspyhf", "-lm", "-o", "test"
    system "./test"
    assert_match version.to_s, shell_output("#{bin}/airspyhf_lib_version").chomp
  end
end
