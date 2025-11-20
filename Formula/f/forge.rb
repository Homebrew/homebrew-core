class Forge < Formula
  desc "High Performance Visualization"
  homepage "https://github.com/arrayfire/forge"
  url "https://github.com/arrayfire/forge/archive/refs/tags/v1.0.8.tar.gz"
  sha256 "77d2581414d6392aa51748454b505a747cd63404f63d3e1ddeafae6a0664419c"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "881a8e394fc90cf10ed91fd8cdec8b046805feabe9872cfe657faeab2281f2a7"
    sha256 cellar: :any,                 arm64_sequoia: "8c0915cfdc9484eebbe0252e8738eb16ae63b7c190a81b601488f1d8b7bad1f5"
    sha256 cellar: :any,                 arm64_sonoma:  "64fad9bd021d5d62a6242e6d5779ce8ae9d99b287507807289fce8ce6a77fce8"
    sha256 cellar: :any,                 sonoma:        "4dd5af8ea60cb6b21df5db738bd2f4da9197f31a6c57858a0915533d0d26cf2c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f457ab3e2f70eb0b2b4c98fb9fd7ce6714c99c2d05088f9568d1f350718557ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36ab3de65058a78ead732348764aae2bfbc0c3d30c0ad36c4969ff91f5fe8775"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "pkgconf" => :build

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "glfw"
  depends_on "glm"
  depends_on "libx11"

  on_linux do
    depends_on "mesa"
  end

  def install
    # FreeImage has multiple CVEs (https://github.com/arrayfire/forge/issues/248) and has
    # been dropped by distros like Arch Linux (https://archlinux.org/todo/drop-freeimage/).
    odie "FreeImage should not be a dependency!" if deps.map(&:name).include?("freeimage")

    system "cmake", "-S", ".", "-B", "build", "-DFG_BUILD_EXAMPLES=OFF", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <forge.h>
      #include <iostream>

      int main()
      {
          std::cout << fg_err_to_string(FG_ERR_NONE) << std::endl;
      }
    CPP
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lforge", "-o", "test"
    assert_match "Success", shell_output("./test")
  end
end
