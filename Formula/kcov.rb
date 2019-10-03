class Kcov < Formula
  desc "Code coverage tester for compiled programs, Python, and shell scripts"
  homepage "https://simonkagstrom.github.io/kcov/"
  url "https://github.com/SimonKagstrom/kcov/archive/v37.tar.gz"
  sha256 "a136e3dddf850a8b006509f49cc75383cd44662169e9fec996ec8cc616824dcc"
  head "https://github.com/SimonKagstrom/kcov.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "eb5bc53867f7dc0ebb53216daf6b1ec62ee45036fa36d60ccfa03722644176ed" => :mojave
    sha256 "e5c56807425593829fa59be83f58ba473cdde545216c06fdda54e7e59996f413" => :high_sierra
    sha256 "75e27a93b88782772c9d54db0afcb079f5f1b3d89a6ab1e457306e269c2951a3" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python" => :build

  def install
    mkdir "build" do
      system "cmake", "-DSPECIFY_RPATH=ON", *std_cmake_args, ".."
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"hello.bash").write <<~EOS
      #!/bin/bash
      echo "Hello, world!"
    EOS
    system "#{bin}/kcov", testpath/"out", testpath/"hello.bash"
    assert_predicate testpath/"out/hello.bash/coverage.json", :exist?
  end
end
