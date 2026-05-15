class Armadillo < Formula
  desc "C++ linear algebra library"
  homepage "https://arma.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arma/armadillo-15.2.6.tar.xz"
  sha256 "97cb8ef708541f632e861d005a462dd0367240f81ff96f8e63ebbdd75c8ce55f"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{url=.*?/armadillo[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "11d4eb85e7d80a2b804846aeb957f618044c0e3951705c30167fe9c4906ff4fd"
    sha256 cellar: :any,                 arm64_sequoia: "b60922b24e0dc59c72a8d990d424addccbb4c01d69f47254c060afb29a8f08a0"
    sha256 cellar: :any,                 arm64_sonoma:  "9327afbe1c454639332388827c187650a4984b5aaad44c6347198df5663675c9"
    sha256 cellar: :any,                 sonoma:        "86051d0d93dfd091f2781a25a5b6ee5e752109660601921475d91fa9b70e49ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ec215d0db4784a97dbb6c9aa339e155073fef8251a460d7d196e66f122c5c6c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a3180be474c981b7eec6b041be72f278172d83123a890d241c1816604d5f34e4"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "arpack"
  depends_on "openblas"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DALLOW_OPENBLAS_MACOS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <armadillo>

      int main(int argc, char** argv) {
        std::cout << arma::arma_version::as_string() << std::endl;
      }
    CPP
    system ENV.cxx, "-std=c++14", "test.cpp", "-I#{include}", "-L#{lib}", "-larmadillo", "-o", "test"
    assert_equal version.to_s.to_i, shell_output("./test").to_i
  end
end
