class Mlton < Formula
  desc "Whole-program, optimizing compiler for Standard ML"
  homepage "http://mlton.org"
  url "https://downloads.sourceforge.net/project/mlton/mlton/20180207/mlton-20180207.src.tgz"
  version "20180207"
  sha256 "872cd98da3db720cbe05f673eaa1776d020d828713753f18fa5dd6a268195fef"
  license "HPND"
  revision 1
  head "https://github.com/MLton/mlton.git"

  bottle do
    cellar :any
    sha256 "e4d9e5fec0e55d60bdc81cd6ffc97183ba8cd5c66c78fedcaa0a4272d582144c" => :catalina
    sha256 "2749da8835666e447d6b8ab53046efe6ae8dbc9d85c2183c1fd69138a3988e91" => :mojave
    sha256 "8a759cb940cabd8f547da4eb0d408b466c2afcea6e2ecf76691616885583cca9" => :high_sierra
  end

  depends_on "gmp"

  # The corresponding upstream binary release used to bootstrap.
  resource "bootstrap" do
    on_macos do
      url "https://downloads.sourceforge.net/project/mlton/mlton/20180207/mlton-20180207-1.amd64-darwin.gmp-static.tgz"
      sha256 "bb2d982ef97d6ef4efe078d23a09baf3e52f6fd6c8f1a60016e1624438f487b3"
    end

    on_linux do
      url "https://downloads.sourceforge.net/project/mlton/mlton/20180207/mlton-20180207-1.amd64-linux.tgz"
      sha256 "8e4abdb9f3ef81c01b989a66734dca2a7f4189c55673a1c8bbad54e7cb299838"
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
