class Packcc < Formula
  desc "Parser generator for C"
  homepage "https://github.com/arithy/packcc"
  url "https://github.com/arithy/packcc/archive/refs/tags/v2.2.0.tar.gz"
  sha256 "eeb123e2d328de60e0a4171649c7e4c78b25a08b60de35beffd14f3d8fdbdcc8"
  license "MIT"
  head "https://github.com/arithy/packcc.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_tahoe:   "a985b781ba01f8200c457f8acf7e555c5a00d41e0c959dfb6cdd18ed77114b42"
    sha256 arm64_sequoia: "7d5658437a0ceec144106d77f0bae460683421de720515cbad71e8538c4d7cbe"
    sha256 arm64_sonoma:  "3011badb913ee3f4cb4482502e883c68a6b0a0d369c2a63a3a99ba170c946c4e"
    sha256 arm64_ventura: "255f7aea2aa1751e6f4cefb5bdf94c39b8f467d13367b3e1f5a6ebb7bacb4106"
    sha256 sonoma:        "d4536c19e74530b56251136175507807f63547cbc67cf77c93f6b4545569c046"
    sha256 ventura:       "ff1768a9796d859f9ba44c04f5f7ed04692ea39d9ed62dbc8255713f8badb263"
    sha256 arm64_linux:   "a8f0a5decaf1f6a96c01b770938182ff10da977292f249ffa6a67e94bc411eb4"
    sha256 x86_64_linux:  "ace36e10dc14b5bfa32e9f13355c9b713723148ab1f34e7b9cb90c0782550e01"
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
