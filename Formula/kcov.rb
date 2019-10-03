class Kcov < Formula
  desc "Code coverage tester for compiled programs, Python, and shell scripts"
  homepage "https://simonkagstrom.github.io/kcov/"
  url "https://github.com/SimonKagstrom/kcov/archive/v37.tar.gz"
  sha256 "a136e3dddf850a8b006509f49cc75383cd44662169e9fec996ec8cc616824dcc"
  head "https://github.com/SimonKagstrom/kcov.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e3ef70ca7ef17beaf787f9c347571ad52b5113e5c33ad0f242f5c179ea2eecec" => :catalina
    sha256 "64374d7b480c44d68dbd4deb4f87751581d141f52c79f0380a6be4323d198f06" => :mojave
    sha256 "e7cfa825d48a187b94a9b22d6fe5b6382feaa7fa505c9d283d3405a1cd9d6936" => :high_sierra
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
