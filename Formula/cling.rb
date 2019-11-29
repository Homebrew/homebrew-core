class Cling < Formula
  desc "The cling C++ interpreter"
  homepage "https://root.cern.ch/cling"
  url "https://github.com/root-project/cling.git",
      :tag      => "v0.6",
      :revision => "82ac7bf1870abbedb7fe44f8e34a429538f26a8d"

  bottle do
    cellar :any
    rebuild 1
    sha256 "e9d2d3b1c5f00e6d511323937a231ec4b86c84934a5e7ab7bd8e589720c68230" => :catalina
    sha256 "6278a45d807370fc4d434ceaa518ca48f1149425a301724deac437ffdf5f0d8d" => :mojave
    sha256 "743ebf99fbc9218f313f9423dad4c767d47bdea4e033d42c8eb989ad89b63458" => :high_sierra
  end

  depends_on "cmake" => :build

  resource "clang" do
    url "http://root.cern.ch/git/clang.git",
        :tag      => "cling-v0.6",
        :revision => "02c41d5edd15232b0b25ec1d842403552c2aceb4"
  end

  resource "llvm" do
    url "http://root.cern.ch/git/llvm.git",
        :tag      => "cling-v0.6",
        :revision => "e0b472e46eb5861570497c2b9efabf96f2d4a485"
  end

  def install
    (buildpath/"src").install resource("llvm")
    (buildpath/"src/tools/cling").install buildpath.children - [buildpath/"src"]
    (buildpath/"src/tools/clang").install resource("clang")
    mkdir "build" do
      system "cmake", *std_cmake_args, "../src",
                      "-DCMAKE_INSTALL_PREFIX=#{libexec}",
                      "-DCLING_CXX_PATH=clang++"
      system "make", "install"
    end
    bin.install_symlink libexec/"bin/cling"
    prefix.install_metafiles buildpath/"src/tools/cling"
  end

  test do
    test = <<~EOS
      '#include <stdio.h>' 'printf("Hello!")'
    EOS
    assert_equal "Hello!(int) 6", shell_output("#{bin}/cling #{test}").chomp
  end
end
