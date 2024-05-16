class Cling < Formula
  desc "C++ interpreter"
  homepage "https://root.cern.ch/cling"
  url "https://github.com/root-project/cling.git",
      tag:      "v1.0",
      revision: "ab81cdcc61f26dfd6a31fb141f1f4b335f6922be"
  license any_of: ["LGPL-2.1-only", "NCSA"]

  depends_on "cmake" => :build

  uses_from_macos "libxml2"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  resource "llvm" do
    url "https://github.com/root-project/llvm-project.git",
        tag:      "cling-llvm13-20240318-01",
        revision: "3610201fbe0352a63efb5cb45f4ea4987702c735"
  end

  def install
    (buildpath/"src").install resource("llvm")
    mkdir "build" do
      system "cmake", *std_cmake_args,
                      "-DCMAKE_INSTALL_PREFIX=#{libexec}",
                      "-DLLVM_EXTERNAL_PROJECTS=cling",
                      "-DLLVM_EXTERNAL_CLING_SOURCE_DIR=..",
                      "-DLLVM_ENABLE_PROJECTS=clang",
                      "-DLLVM_TARGETS_TO_BUILD=host;NVPTX",
                      "-DLLVM_BUILD_TOOLS=Off",
                      "../src/llvm"
      system "make", "install"
    end
    bin.install_symlink libexec/"bin/cling"
  end

  test do
    test = <<~EOS
      '#include <stdio.h>' 'printf("Hello!")'
    EOS
    assert_equal "Hello!(int) 6", shell_output("#{bin}/cling #{test}").chomp
  end
end
