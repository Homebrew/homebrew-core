class Physunits < Formula
  desc "C++ header-only for Physics unit/quantity manipulation and conversion"
  homepage "https://github.com/martinmoene/PhysUnits-CT-Cpp11"
  url "https://github.com/martinmoene/PhysUnits-CT-Cpp11/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "4d1f3a4901ef910ae492ed7c5719da0c68f4f3a8551cdfbc90e3ab8aa02ab882"
  license "BSL-1.0"
  head "https://github.com/martinmoene/PhysUnits-CT-Cpp11.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e4d6c75204e45953990cd24da453433b51fecadea96fae5565348329c66fd687"
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
