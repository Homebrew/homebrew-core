class Cling < Formula
  desc "The cling C++ interpreter"
  homepage "https://root.cern.ch/cling"
  url "https://github.com/root-project/cling.git",
      :tag      => "v0.5",
      :revision => "0f1d6d24d4417fc02b73589c8b1d813e92de1c3f"
  revision 2

  bottle do
    sha256 "b6e842db192bc4ebbf88d5f6cffa8acfb1967d959ddf823cca0a6e522900f410" => :mojave
    sha256 "fe94e56a3ee12dc8ada76ab4e9f96f4ff754f356a9ca9ad35708c0dbf4a41802" => :high_sierra
    sha256 "c947df2499dcdeaa9807c3eae023d5c5cf9ba49902a68998e242b24e0fedcd9f" => :sierra
    sha256 "a735b768dd2e5b9b000ca81660d5472897036d331277595501b341075da5ee8b" => :el_capitan
  end

  depends_on "cmake" => :build

  resource "clang" do
    url "http://root.cern.ch/git/clang.git",
        :tag      => "cling-patches-r302975",
        :revision => "1f8b137c7eb06ed8e321649ef7e3f3e7a96f361c"
  end

  resource "llvm" do
    url "http://root.cern.ch/git/llvm.git",
        :tag      => "cling-patches-r302975",
        :revision => "2a34248cb945d63ded5ee55128e68efd7e5b87c8"
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
