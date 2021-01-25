class Mlton < Formula
  desc "Whole-program, optimizing compiler for Standard ML"
  homepage "http://mlton.org"
  url "https://downloads.sourceforge.net/project/mlton/mlton/20210117/mlton-20210117.src.tgz"
  sha256 "ec7a5a54deb39c7c0fa746d17767752154e9cb94dbcf3d15b795083b3f0f154b"
  license "HPND"
  head "https://github.com/MLton/mlton.git"

  livecheck do
    url :stable
    regex(%r{url=.*?/mlton[._-]v?(\d+(?:\.\d+)*(?:-\d+)?)[._-]src\.t}i)
  end

  bottle do
    cellar :any
    sha256 "17689a4038de312508541279c5d6f8be7fc695af642e9691810d67b65c68289c" => :big_sur
    sha256 "5b874e9fc91c7c868faccb85daf65bbe2553eb31c2a4d499d839c60a22dd7b5c" => :catalina
    sha256 "099192143e94c33e015832650e9a445458df745ce65a6702e1ddf328cf60c8e0" => :mojave
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gmp"

  # The corresponding upstream binary release used to bootstrap.
  resource "bootstrap" do
    on_macos do
      # https://github.com/Homebrew/homebrew-core/pull/58438#issuecomment-665375929
      # new `mlton-20210117-1.amd64-darwin-17.7.gmp-static.tgz` artifact
      # used here for bootstrapping all homebrew versions
      url "https://downloads.sourceforge.net/project/mlton/mlton/20210117/mlton-20210117-1.amd64-darwin-19.6.gmp-static.tgz"
      sha256 "5bea9f60136ea6847890c5f4e45d7126a32ef14fd46a2303cab875ca95c8cd76"
    end

    on_linux do
      url "https://downloads.sourceforge.net/project/mlton/mlton/20210117/mlton-20210117-1.amd64-linux.tgz"
      sha256 "25876b075e95b0e70677bd5eeebb791a871629376044f358b908678b8f9b605d"
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
