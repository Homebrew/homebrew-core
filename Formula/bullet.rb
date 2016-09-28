class Bullet < Formula
  desc "Physics SDK"
  homepage "http://bulletphysics.org/wordpress/"
  url "https://github.com/bulletphysics/bullet3/archive/2.83.7.tar.gz"
  sha256 "00d1d8f206ee85ffd171643ac8e72f9f4e0bf6dbf3d4ac55f4495cb168b51243"
  head "https://github.com/bulletphysics/bullet3.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c40652f885e1a4c46007591a2499dc54fee0b8c720795f7d73d7dc3d880d1ac7" => :sierra
    sha256 "76ccbd35bad9d8314034ff565faaa0554780ccb824a8e2f8e0f2c8e6d943c36f" => :el_capitan
    sha256 "f1820f7ee747911117fc28eef8fee1d9e4cb4d776aa5f26c575edc5545a3d995" => :yosemite
    sha256 "affa568baabe79d993fe27eaa89466d1e837002754dd407f595a9c992eef58c4" => :mavericks
  end

  deprecated_option "framework" => "with-framework"
  deprecated_option "shared" => "with-shared"
  deprecated_option "build-demo" => "with-demo"
  deprecated_option "double-precision" => "with-double-precision"

  option :universal
  option "with-framework", "Build frameworks"
  option "with-shared", "Build shared libraries"
  option "with-demo", "Build demo applications"
  option "with-double-precision", "Use double precision"

  depends_on "cmake" => :build

  def install
    args = ["-DINSTALL_EXTRA_LIBS=ON"]

    if build.with? "framework"
      args << "-DBUILD_SHARED_LIBS=ON" << "-DFRAMEWORK=ON"
      args << "-DCMAKE_INSTALL_PREFIX=#{frameworks}"
      args << "-DCMAKE_INSTALL_NAME_DIR=#{frameworks}"
    else
      args << "-DBUILD_SHARED_LIBS=ON" if build.with? "shared"
      args << "-DCMAKE_INSTALL_PREFIX=#{prefix}"
    end

    if build.universal?
      ENV.universal_binary
      args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.universal_archs.as_cmake_arch_flags}"
    end

    args << "-DUSE_DOUBLE_PRECISION=ON" if build.with? "double-precision"

    # Related to the following warnings when building --with-shared --with-demo
    # https://gist.github.com/scpeters/6afc44f0cf916b11a226
    if build.with?("demo") && (build.with?("shared") || build.with?("framework"))
      raise "Demos cannot be installed with shared libraries or framework."
    end

    args << "-DBUILD_BULLET2_DEMOS=OFF" if build.without? "demo"

    system "cmake", *args
    system "make"
    system "make", "install"

    prefix.install "examples" if build.with? "demo"
    prefix.install "Extras" if build.with? "extra"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include "bullet/LinearMath/btPolarDecomposition.h"
      int main() {
        btMatrix3x3 I = btMatrix3x3::getIdentity();
        btMatrix3x3 u, h;
        polarDecompose(I, u, h);
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lLinearMath", "-lc++", "-o", "test"
    system "./test"
  end
end
