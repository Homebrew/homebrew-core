class Packcc < Formula
  desc "Parser generator for C"
  homepage "https://github.com/arithy/packcc"
  url "https://github.com/arithy/packcc/archive/refs/tags/v3.1.0.tar.gz"
  sha256 "26fa5c99ea36c4632fcb231479d01f354d016d2d8d97d74c44c08bc1924ae0a6"
  license "MIT"
  head "https://github.com/arithy/packcc.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_tahoe:   "48a1bbbb6c7a797742b5f50f84739d27845f560da0f40e0e5157d539b2a185d6"
    sha256 arm64_sequoia: "39534f1afb2fe241fac5cc52f79b37001e947ed4cdac51160370edf634bed2c8"
    sha256 arm64_sonoma:  "3951ab5b93befba94e4f5b8360677876b98660f4ceace02c0c421d7860b8291e"
    sha256 sonoma:        "7a0f38214655906b2eee5a876ce39945b14a10687f3f0003e07545e085569d6b"
    sha256 arm64_linux:   "534844353e0bd45f7bcc5d16095eb8f971c5a41e9944b735f180454a8bbe49cb"
    sha256 x86_64_linux:  "0b85c82b66f6b05e007a77f2bf4c23cc402a06ffa843e772345f77390d036684"
  end

  depends_on "cmake" => :build

  def install
    inreplace "src/packcc.c", "/usr/share/packcc/import", "#{opt_pkgshare}/import"

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples"
  end

  test do
    cp pkgshare/"examples/ast-calc.v3.peg", testpath
    system bin/"packcc", "ast-calc.v3.peg"
    system ENV.cc, "ast-calc.v3.c", "-o", "ast-calc"
    output = pipe_output(testpath/"ast-calc", "1+2*3\n")
    assert_equal <<~EOS, output
      binary: "+"
        nullary: "1"
        binary: "*"
          nullary: "2"
          nullary: "3"
    EOS
  end
end
