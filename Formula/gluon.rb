class Gluon < Formula
  desc "Static, type inferred and embeddable language written in Rust"
  homepage "https://gluon-lang.org"
  url "https://github.com/gluon-lang/gluon/archive/v0.17.2.tar.gz"
  sha256 "8fc8cc2211cff7a3d37a64c0b1f0901767725d3c2c26535cb9aabbfe921ba18e"
  license "MIT"
  head "https://github.com/gluon-lang/gluon.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb0ca82a9d8791cc2ecb55f93d913256a4bd741b9c96ec1e65580f3144d0717e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "62a081e09aff7da0df608c4b9c7a852e75c2226d5953bc0a938af6fb716b793e"
    sha256 cellar: :any_skip_relocation, monterey:       "4e0368654ce134df2cbf05aa1f3d449019a34dc1c9b30a4d44cd89c58b82fa87"
    sha256 cellar: :any_skip_relocation, big_sur:        "4c46d2aa89cd80b3fd135f8160019076bc0f01a208a561ef63d84e7959a5d64e"
    sha256 cellar: :any_skip_relocation, catalina:       "abea6a7007ec7663a5d3d8994a8028412843d45210b5b17723f2bcb0dc43134b"
    sha256 cellar: :any_skip_relocation, mojave:         "b6a865cd7da1a201a008ae65478191082501e1dc9ab7b6dae189e4f2f2bef8e4"
    sha256 cellar: :any_skip_relocation, high_sierra:    "847b61a0a4b7d4afc4598301c5bbf6afac3e70c737cdb0a26ad0438db42b1e44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79ec69866a1f38afa5fa00eda1c76817b2b81162f7977f9da1ad0efe1a3f111b"
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
