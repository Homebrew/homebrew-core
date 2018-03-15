class Mlton < Formula
  desc "Whole-program, optimizing compiler for Standard ML"
  homepage "http://mlton.org"
  url "https://downloads.sourceforge.net/project/mlton/mlton/20180207/mlton-20180207.src.tgz"
  version "20180207"
  sha256 "872cd98da3db720cbe05f673eaa1776d020d828713753f18fa5dd6a268195fef"
  head "https://github.com/MLton/mlton.git"

  bottle do
    cellar :any
    sha256 "c3712458c252eba59c3b370f99662cc02e06f6aad3b5e0bb5abe6980541bac9c" => :high_sierra
    sha256 "7605c1540d4449fdcda1802ee31dd891dc3d197081747744b575300bebe9000c" => :sierra
    sha256 "7182b0b044b789e03f99577dc993e0cb9737b9c175dd17815018fa777d0f4214" => :el_capitan
  end

  depends_on "gmp"

  # The corresponding upstream binary release used to bootstrap.
  resource "bootstrap" do
    url "https://downloads.sourceforge.net/project/mlton/mlton/20180207/mlton-20180207-1.amd64-darwin.gmp-static.tgz"
    sha256 "bb2d982ef97d6ef4efe078d23a09baf3e52f6fd6c8f1a60016e1624438f487b3"
  end

  def install
    # Install the corresponding upstream binary release to 'bootstrap'.
    bootstrap = buildpath/"bootstrap"
    resource("bootstrap").stage do
      args = %W[
        WITH_GMP=#{Formula["gmp"].opt_prefix}
        PREFIX=#{bootstrap}
        MAN_PREFIX_EXTRA=/share
      ]
      system "make", *(args + ["install"])
    end
    ENV.prepend_path "PATH", bootstrap/"bin"

    # Support parallel builds (https://github.com/MLton/mlton/issues/132)
    ENV.deparallelize
    args = %W[
      WITH_GMP=#{Formula["gmp"].opt_prefix}
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
