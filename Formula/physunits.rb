class Physunits < Formula
  desc "C++ header-only for Physics unit/quantity manipulation and conversion"
  homepage "https://github.com/martinmoene/PhysUnits-CT-Cpp11"
  url "https://github.com/martinmoene/PhysUnits-CT-Cpp11/archive/v1.2.0.tar.gz"
  # version "v1.2.0"
  sha256 "e9bcce99d9c90ac8ce96746eff49c20b7c9717aee08b3cd6e58127c7ad9fa7c6"

  depends_on "cmake" => :build

  def install
    mkdir "phys-build" do
      args = std_cmake_args + %w[
        ../
      ]

      system "cmake", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
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
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", "-I#{include}"
    assert_match /12.5/, shell_output("./test")
  end
end
