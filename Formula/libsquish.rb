class Libsquish < Formula
  desc "Library for compressing images with the DXT standard"
  homepage "https://sourceforge.net/projects/libsquish/"
  url "https://downloads.sourceforge.net/project/libsquish/libsquish-1.15.tgz"
  sha256 "628796eeba608866183a61d080d46967c9dda6723bc0a3ec52324c85d2147269"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, monterey:    "904c64da3dfb66597dfcad1afdb70ff5f14984fa69f37d7386592a3bbd49012b"
    sha256 cellar: :any_skip_relocation, big_sur:     "bfc3e9d3b6239828025e5a35707ac35a82722c9a1f66b13116990a3597f33943"
    sha256 cellar: :any_skip_relocation, catalina:    "a3f9fc5e20792dd4ced369a1be063a01c873afc399c8c73bb8800db1777ce6fb"
    sha256 cellar: :any_skip_relocation, mojave:      "d3a42b4342fab6548ec4e2467a571631edf0891d1c4c51a6573b14afda5b0972"
    sha256 cellar: :any_skip_relocation, high_sierra: "734574ea8d63c2d52f291c1d3c96e18ee7fb6f404b5039245a31625fcb6277df"
    sha256 cellar: :any_skip_relocation, sierra:      "ebfa2b4d94a71334548800ceb00803ed1ed1e91226f6892048f376d73ee7ef74"
    sha256 cellar: :any_skip_relocation, el_capitan:  "4af6195448040889de7ada48fcb6fc6dd945e47f001a04807b70b4f5b3982663"
    sha256 cellar: :any_skip_relocation, yosemite:    "d887794fa29f03abcd3809db6ea74045d3b8d40d895cf5972d2eda3de86f3ada"
  end

  depends_on "cmake" => :build

  def install
    # Static and shared libraries have to be built using separate calls to cmake.
    args = []
    args << "-DBUILD_SQUISH_WITH_SSE2=OFF" if Hardware::CPU.arm?
    system "cmake", "-S", ".", "-B", "build_static", *std_cmake_args, *args
    system "cmake", "--build", "build_static"
    lib.install "build_static/libsquish.a"

    args << "-DBUILD_SHARED_LIBS=ON"
    system "cmake", "-S", ".", "-B", "build_shared", *std_cmake_args, *args
    system "cmake", "--build", "build_shared"
    system "cmake", "--install", "build_shared"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <stdio.h>
      #include <squish.h>
      int main(void) {
        printf("%d", GetStorageRequirements(640, 480, squish::kDxt1));
        return 0;
      }
    EOS
    system ENV.cxx, "-o", "test", "test.cc", "-L#{lib}", "-lsquish"
    assert_equal "153600", shell_output("./test")
  end
end
