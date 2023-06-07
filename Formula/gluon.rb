class Gluon < Formula
  desc "Static, type inferred and embeddable language written in Rust"
  homepage "https://gluon-lang.org"
  url "https://github.com/gluon-lang/gluon/archive/v0.18.0.tar.gz"
  sha256 "1532cae94c85c9172e0b96b061384c448e6e1b35093d1aacf0cd214e751fe1e3"
  license "MIT"
  head "https://github.com/gluon-lang/gluon.git", branch: "master"

  # There's a lot of false tags here.
  # Those prefixed with 'v' seem to be ok.
  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "772237093841dd3c01a7370dff7f9a36a22db5661b5838129b5e64836838ed46"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "856724c80aca4147aa43da1f46c03113ff95364e38e6dd9d1eb60bb393630f0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d97b9493f40381d9df5020efc6b36b99854a7f30df2d032f2c230705acf09dff"
    sha256 cellar: :any_skip_relocation, ventura:        "9dde5bfb5376eb312a217d4c847c7b7640713aa2d9d8737202b75988eb6edb97"
    sha256 cellar: :any_skip_relocation, monterey:       "68a5decef287473baeeb071ce82c2662a3076a6acca56d1026e02e9a4ddb6cf1"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9db415b52c1f8113f7c3a46478282dd627a8c9035772b8455968888c96a8b7f"
    sha256 cellar: :any_skip_relocation, catalina:       "873f425fb7417041c09b67efe496f1bb99b7631f2a24c2e9115875f4efe7e273"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8f2c8e631a2a1c180688996cde7d4e87dcd8f257c74a0bf5ac61798ffe48530"
  end

  depends_on "rust" => :build

  # Fix compile with newer Rust.
  # Remove with 0.19.
  patch do
    url "https://github.com/gluon-lang/gluon/commit/f30127bf5e27520d41a654154381c2e9601d2f3e.patch?full_index=1"
    sha256 "bcfb2d0c36104a30745f7e6ddc4c8650ed60cb969f1e55cd4e6bb2cb6fe48722"
  end

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
