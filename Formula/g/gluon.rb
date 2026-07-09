class Gluon < Formula
  desc "Static, type inferred and embeddable language written in Rust"
  homepage "https://gluon-lang.org"
  url "https://github.com/gluon-lang/gluon/archive/refs/tags/v0.18.3.tar.gz"
  sha256 "3fe104db4e5879fde335aeec9cd2b444f3323c1b834d61d806862e66edfb3e4d"
  license "MIT"
  head "https://github.com/gluon-lang/gluon.git", branch: "master"

  # There's a lot of false tags here.
  # Those prefixed with 'v' seem to be ok.
  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2fe7b405aa8961561ea3e7e22171e6c29b49ac9a7964b316598028de1384ad3e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c2b2a93b731ac8e897e884535659e478538ffac1663e416c076c3813825dbe15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4b72f948d84efad899dbde170400a03aa4635afba7e3be132a4ebc34be5624f3"
    sha256 cellar: :any_skip_relocation, sonoma:        "2b1b5f8e4d99130b06cfaeaf49f910560e4694b2fe5a49fa899274602ce0fa00"
    sha256 cellar: :any,                 arm64_linux:   "73873c174a4538f6b4957eb334e04cc24daf966bfd1b548389a0c0a724cc0f3f"
    sha256 cellar: :any,                 x86_64_linux:  "22bc694ada74091452ef704c3c4448a51c0b154c14ff1af2fa0ff8b0fb0b08cc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "repl")
  end

  test do
    (testpath/"test.glu").write <<~EOS
      let io = import! std.io
      io.print "Hello world!\\n"
    EOS
    assert_equal "Hello world!\n", shell_output("#{bin}/gluon test.glu")
  end
end
