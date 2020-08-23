class Mlton < Formula
  desc "Whole-program, optimizing compiler for Standard ML"
  homepage "http://mlton.org"
  url "https://downloads.sourceforge.net/project/mlton/mlton/20200722/mlton-20200722.src.tgz"
  sha256 "b65ac4a674a1c427c960d4bc067c9ce200c90b6e01294f146d429225e9d26d63"
  license "HPND"
  head "https://github.com/MLton/mlton.git"

  bottle do
    cellar :any
    sha256 "7bda06d08d43eb4c2417c9b4e69b9ab8925dbe320b4e9960450d596207abad6a" => :catalina
    sha256 "8f1f91096c4acd761162942a66f37011b1df0836b2cc3f577808649ea2c0483e" => :mojave
    sha256 "3c8688c9ba18d0662fd095a59e14e6b40ae41f4cf2c6387902aa9c18fdb069c4" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gmp"

  # The corresponding upstream binary release used to bootstrap.
  resource "bootstrap" do
    on_macos do
      # https://github.com/Homebrew/homebrew-core/pull/58438#issuecomment-665375929
      # new `mlton-20200722-1.amd64-darwin-17.7.gmp-static.tgz` artifact
      # used here for bootraping all homebrew versions
      url "https://downloads.sourceforge.net/project/mlton/mlton/20200722/mlton-20200722-1.amd64-darwin-17.7.gmp-static.tgz"
      sha256 "dbfeb325427d1d19b259b8054d5a85ffc2681b42df00cc8340809761dcc5120b"
    end

    on_linux do
      url "https://downloads.sourceforge.net/project/mlton/mlton/20200722/mlton-20200722-1.amd64-linux.tgz"
      sha256 "2829b0d138a6664022c14b0814aae82f68fba3f8443dd454737697ad6cce4b92"
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
