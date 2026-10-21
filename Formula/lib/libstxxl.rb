class Libstxxl < Formula
  desc "C++ implementation of STL for extra large data sets"
  homepage "https://stxxl.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/stxxl/stxxl/1.4.1/stxxl-1.4.1.tar.gz"
  sha256 "92789d60cd6eca5c37536235eefae06ad3714781ab5e7eec7794b1c10ace67ac"
  license "BSL-1.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c551ef2ed7fbb9a13218b7cb6a1640fe56bb94ba4cd4c1e945466c0acf70ed0f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "03c216058f8bc2bcc297b0703e6138afbb06eb45b4e2ac46cd72338d99afdb49"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ac60f2dfc0086a695e795f12152c7738118487cfe73195a0b26d4642e75fe668"
    sha256 cellar: :any,                 arm64_linux:       "116a180c7ea88a3d33344e6aba74ae73bc71948c62f0b2589a71127d29e3499c"
    sha256 cellar: :any,                 x86_64_linux:      "6661e2db6c85d5b2012445d59fa16804543eb328690fefde1b8bf22271c94cd7"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :test

  deny_network_access!

  def install
    # Workaround to build with CMake 4
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/".stxxl").write "disk=#{testpath}/stxxl.tmp,64MiB,syscall delete\n"
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <stxxl/vector>

      int main() {
        stxxl::VECTOR_GENERATOR<int>::result v;
        for (int i = 0; i < 1000; i++) v.push_back(i);
        std::cout << v.size() << " " << v[999] << std::endl;
        return 0;
      }
    CPP
    pkgconf_flags = shell_output("pkgconf --cflags --libs stxxl").chomp.split
    args = %w[-std=c++11 test.cpp -o test] + pkgconf_flags
    args += %w[-fopenmp -pthread] if OS.linux?
    system ENV.cxx, *args
    assert_match "1000 999", shell_output("./test")

    assert_match "sizeof(void*)", shell_output("#{bin}/stxxl_tool info")
  end
end
