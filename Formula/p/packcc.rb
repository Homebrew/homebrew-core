class Packcc < Formula
  desc "Parser generator for C"
  homepage "https://github.com/arithy/packcc"
  url "https://github.com/arithy/packcc/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "9f4d486ff34ff191cb01bd6ac41e707e93a90a581f997d45414422958af142f6"
  license "MIT"
  head "https://github.com/arithy/packcc.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "3d37ed91a62162fbb2cfb2d37e196177a3584e43c18bfb938be202052a8219b3"
    sha256 arm64_sonoma:  "21241274aba27be73f8ff6390bb869d8156fa6d10600fef5b1700c14a4ced794"
    sha256 arm64_ventura: "ec0467faea2cfa65c990ceb31fe1abfd7ed10ede453ba4544b8f445d241af1bb"
    sha256 sonoma:        "30b0c8452bd024c265e2199bfbde85b7d87def62dbf6f7138ef4109feeff8286"
    sha256 ventura:       "8798726082b26db0a5d03b25f0e4928d91f7f2f44ca2a8d735e6df20e7c95eb0"
    sha256 x86_64_linux:  "9cff89541011aba3df7ed2ee6cc72c08fd3afce9ab9cecb82a57c1d812ab7609"
  end

  def install
    inreplace "src/packcc.c", "/usr/share/packcc/", "#{pkgshare}/"
    build_dir = buildpath/"build"/ENV.compiler.to_s.sub(/-\d+$/, "")
    system "make", "-C", build_dir
    bin.install build_dir/"release/bin/packcc"
    pkgshare.install "examples", "import"
  end

  test do
    cp pkgshare/"examples/ast-calc.peg", testpath
    system bin/"packcc", "ast-calc.peg"
    system ENV.cc, "ast-calc.c", "-o", "ast-calc"
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
