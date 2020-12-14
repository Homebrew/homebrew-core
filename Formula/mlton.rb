class Mlton < Formula
  desc "Whole-program, optimizing compiler for Standard ML"
  homepage "http://mlton.org"
  url "https://downloads.sourceforge.net/project/mlton/mlton/20201002/mlton-20201002.src.tgz"
  sha256 "ec189157de69e4d1fd6413452b7386c6622696c01200632176a08904f98be9e6"
  license "HPND"
  head "https://github.com/MLton/mlton.git"

  livecheck do
    url :stable
    regex(%r{url=.*?/mlton[._-]v?(\d+(?:\.\d+)*(?:-\d+)?)[._-]src\.t}i)
  end

  bottle do
    cellar :any
    sha256 "6532f2264aeade862542d23116a004298b942b5da8e8c58b63d09f8cb370aca7" => :big_sur
    sha256 "74c855912e47a0ab45209380c066a307e98a801c43ceeb6f724984daeee2235f" => :catalina
    sha256 "339877740be650978b454a95cc37a4295cd6f2030c19914513463f73b5696986" => :mojave
    sha256 "c47f72b8ab349204f5b4ad00c5f1d2018a22be49e1eb39da3416648698dcce1b" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gmp"

  # The corresponding upstream binary release used to bootstrap.
  resource "bootstrap" do
    on_macos do
      # https://github.com/Homebrew/homebrew-core/pull/58438#issuecomment-665375929
      # new `mlton-20201002-1.amd64-darwin-17.7.gmp-static.tgz` artifact
      # used here for bootstrapping all homebrew versions
      url "https://downloads.sourceforge.net/project/mlton/mlton/20201002/mlton-20201002-1.amd64-darwin-17.7.gmp-static.tgz"
      sha256 "737adc5590b9d010ba3654344103418bf6c70aebc66d98849f7e0f37ef386114"
    end

    on_linux do
      url "https://downloads.sourceforge.net/project/mlton/mlton/20201002/mlton-20201002-1.amd64-linux.tgz"
      sha256 "8d4bd9358fda1ecb8eeee1414866bf730aa5d7fe5425ef24635c45daf5277a0b"
    end
  end

  def install
    # Install the corresponding upstream binary release to 'bootstrap'.
    bootstrap = buildpath/"bootstrap"
    resource("bootstrap").stage do
      args = %W[
        WITH_GMP_DIR=#{Formula["gmp"].opt_prefix}
        PREFIX=#{bootstrap}
        MAN_PREFIX_EXTRA=/share
      ]
      system "make", *(args + ["install"])
    end
    ENV.prepend_path "PATH", bootstrap/"bin"

    # Support parallel builds (https://github.com/MLton/mlton/issues/132)
    ENV.deparallelize
    args = %W[
      WITH_GMP_DIR=#{Formula["gmp"].opt_prefix}
      DESTDIR=
      PREFIX=#{prefix}
      MAN_PREFIX_EXTRA=/share
    ]
    system "make", *(args + ["all"])
    system "make", *(args + ["install"])
  end

  test do
    (testpath/"hello.sml").write <<~'EOS'
      val () = print "Hello, Homebrew!\n"
    EOS
    system "#{bin}/mlton", "hello.sml"
    assert_equal "Hello, Homebrew!\n", `./hello`
  end
end
