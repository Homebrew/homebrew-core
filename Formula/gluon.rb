class Gluon < Formula
  desc "Static, type inferred and embeddable language written in Rust"
  homepage "https://gluon-lang.org"
  url "https://github.com/gluon-lang/gluon/archive/v0.17.2.tar.gz"
  sha256 "8fc8cc2211cff7a3d37a64c0b1f0901767725d3c2c26535cb9aabbfe921ba18e"
  license "MIT"
  head "https://github.com/gluon-lang/gluon.git"

  livecheck do
    url "https://github.com/gluon-lang/gluon/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "abea6a7007ec7663a5d3d8994a8028412843d45210b5b17723f2bcb0dc43134b" => :catalina
    sha256 "b6a865cd7da1a201a008ae65478191082501e1dc9ab7b6dae189e4f2f2bef8e4" => :mojave
    sha256 "847b61a0a4b7d4afc4598301c5bbf6afac3e70c737cdb0a26ad0438db42b1e44" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    cd "repl" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    (testpath/"test.glu").write <<~EOS
      let io = import! std.io
      io.print "Hello world!\\n"
    EOS
    assert_equal "Hello world!\n", shell_output("#{bin}/gluon test.glu")
  end
end
