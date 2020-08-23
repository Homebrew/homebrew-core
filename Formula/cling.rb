class Cling < Formula
  desc "The cling C++ interpreter"
  homepage "https://root.cern.ch/cling"
  url "https://github.com/root-project/cling.git",
      tag:      "v0.6",
      revision: "82ac7bf1870abbedb7fe44f8e34a429538f26a8d"
  # You may license this software under one of the following licenses, marked
  # "UI/NCSAOSL" and "LGPL".
  license "LGPL-2.1"

  bottle do
    cellar :any
    sha256 "9ab4ced2f1cda06858656f78b5ffb7fd1ab680d8b26680e353e71eb7b6c5601b" => :catalina
    sha256 "e630699239fadc14a1d6b2a62474a9e6c21f187642af66f92df1a49d5e7c899c" => :mojave
    sha256 "381326c7944d38195c9b8507db18aa35fa636dc8c08f876472db0d7577ce597b" => :high_sierra
  end

  depends_on "cmake" => :build

  resource "clang" do
    url "http://root.cern.ch/git/clang.git",
        tag:      "cling-v0.6",
        revision: "02c41d5edd15232b0b25ec1d842403552c2aceb4"
  end

  resource "llvm" do
    url "http://root.cern.ch/git/llvm.git",
        tag:      "cling-v0.6",
        revision: "e0b472e46eb5861570497c2b9efabf96f2d4a485"
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
