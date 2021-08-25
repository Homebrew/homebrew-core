class Bond < Formula
  desc "Cross-platform framework for working with schematized data"
  homepage "https://github.com/microsoft/bond"
  url "https://github.com/microsoft/bond/archive/9.0.5.tar.gz"
  sha256 "53ee8a325c34136495a1568ca8f0740d4527b74efa0ff71c7d927971fad0dc82"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 big_sur:      "9cc49b023fbd14c296f04cd5ae537bf6098f9b09025812a350a99a72bed00fea"
    sha256 cellar: :any,                 catalina:     "5d78ce28f6865648b61de0d5fc449c13e6ebc3093209efe781073d560b1b29b7"
    sha256 cellar: :any,                 mojave:       "54718f979d4ee63570fe76d4d96682f1c169791c3e1b91fc32471aee3bcccd0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "6580ebb4d4dad6e1c0d77ea8799b5fb106f315664f27c4bad881fa3c6f667e6d"
  end

  depends_on "cmake" => :build
  depends_on "ghc@8.6" => :build
  depends_on "haskell-stack" => :build
  depends_on "boost"
  depends_on "rapidjson"

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
