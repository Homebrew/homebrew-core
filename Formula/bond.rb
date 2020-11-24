class Bond < Formula
  desc "Cross-platform framework for working with schematized data"
  homepage "https://github.com/microsoft/bond"
  url "https://github.com/microsoft/bond/archive/9.0.4.tar.gz"
  sha256 "59392145dbe271c3f1fd4b784958a08cf5c9e38c1a769af007ce6ac7100daf01"
  license "MIT"

  bottle do
    cellar :any
    rebuild 1
    sha256 "cb4ef09d092f549b6d1560a45495a0409ee833cc704f19f19a6c686b98d5dc7d" => :big_sur
    sha256 "6673df7678225c039e6109c31b900c08dd17c1dc37f13354e037380165826f17" => :catalina
    sha256 "20e6e5f4f5885095067f0f477260561ff8f8e6e17408f06473d7bf54bc70d4a2" => :mojave
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
