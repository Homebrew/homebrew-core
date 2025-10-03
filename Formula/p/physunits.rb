class Physunits < Formula
  desc "C++ header-only for Physics unit/quantity manipulation and conversion"
  homepage "https://github.com/martinmoene/PhysUnits-CT-Cpp11"
  url "https://github.com/martinmoene/PhysUnits-CT-Cpp11/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "64187aadf886f9bade5976f5f3289637f8882f36ac4767f1be201f89e5a4a47d"
  license "BSL-1.0"
  head "https://github.com/martinmoene/PhysUnits-CT-Cpp11.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0d821322abd11d644d0dbf1fe20bbee6fc39a44f2e2404eea9f0e5042605d772"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "builddir", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
    system "cmake", "--build", "builddir"
    system "cmake", "--install", "builddir"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <phys/units/quantity.hpp>
      #include <iostream>
      using namespace std;
      using namespace phys::units;
      using namespace phys::units::literals;

      int main()
      {
        quantity<speed_d> speed = 45_km / hour;
        cout<<speed.magnitude()<<endl;
      }
    CPP

    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}"
    assert_match(/12.5/, shell_output("./test"))
  end
end
