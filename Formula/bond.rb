class Bond < Formula
  desc "Cross-platform framework for working with schematized data"
  homepage "https://github.com/microsoft/bond"
  url "https://github.com/microsoft/bond/archive/10.0.0.tar.gz"
  sha256 "87858b597a1da74421974d5c3cf3a9ea56339643b19b48274d44b13bc9483f29"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 monterey:     "7c8b0675dd3148dee7a8cf6fd0a73fb870e1979a9a2121af9bd8486e3cc12f78"
    sha256 cellar: :any,                 big_sur:      "31b834df421932bba76bc64d08b6a6900d6c05205c87e4f3d8c4e4218c3a953e"
    sha256 cellar: :any,                 catalina:     "d20864dea9b364962c2025a463ca19cc1136a633df86ff5d1f59b44ae9262f38"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c5c047bff8729f94818174f40051191e242ccd8383553b30b18e0bc598847126"
  end

  depends_on "cmake" => :build
  depends_on "ghc@8.6" => :build
  depends_on "haskell-stack" => :build
  depends_on "boost"
  depends_on "rapidjson"

  uses_from_macos "xz" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DBOND_ENABLE_GRPC=FALSE",
                            "-DBOND_FIND_RAPIDJSON=TRUE",
                            "-DBOND_STACK_OPTIONS=--system-ghc;--no-install-ghc"
      system "make"
      system "make", "install"
    end
    chmod 0755, bin/"gbc"
    pkgshare.install "examples"
  end

  test do
    cp_r pkgshare/"examples/cpp/core/serialization/.", testpath
    system bin/"gbc", "c++", "serialization.bond"
    system ENV.cxx, "-std=c++11", "serialization_types.cpp", "serialization.cpp",
                    "-o", "test", "-L#{lib}/bond", "-lbond", "-lbond_apply"
    system "./test"
  end
end
