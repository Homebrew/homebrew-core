class Mlton < Formula
  desc "Whole-program, optimizing compiler for Standard ML"
  homepage "http://mlton.org"
  url "https://downloads.sourceforge.net/project/mlton/mlton/20200817/mlton-20200817.src.tgz"
  sha256 "8a700589b99d49346a0d1f51529cac682a7fef7a259762d5a007069e1948499f"
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
      # new `mlton-20200817-1.amd64-darwin-17.7.gmp-static.tgz` artifact
      # used here for bootraping all homebrew versions
      url "https://downloads.sourceforge.net/project/mlton/mlton/20200817/mlton-20200817-1.amd64-darwin-17.7.gmp-static.tgz"
      sha256 "3cd12d5d3db047270b6e678c3488063c3179294a8d4907fa11be2f7327459c27"
    end

    on_linux do
      url "https://downloads.sourceforge.net/project/mlton/mlton/20200817/mlton-20200817-1.amd64-linux.tgz"
      sha256 "8adab32d37e9c9c2986a0cfeba0aa4e29541d0e6a19178e7393797feaf32db40"
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
