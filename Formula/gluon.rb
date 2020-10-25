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
    sha256 "a33dc9492de59e81d955a15cc08683642a2b9212f634ac34b05dc655a3b78b0b" => :catalina
    sha256 "8afb0cf0ee97de2828321adb5998543c6b2fc1a923da02974ddf6a789bbf3d1b" => :mojave
    sha256 "aa7eb03685fd24f3b5a2f1f71268279cff482cbcda5c998a1850c209bd22ea47" => :high_sierra
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
