class Mlton < Formula
  desc "Whole-program, optimizing compiler for Standard ML"
  homepage "http://mlton.org"
  url "https://downloads.sourceforge.net/project/mlton/mlton/20180207/mlton-20180207.src.tgz"
  version "20180207"
  sha256 "872cd98da3db720cbe05f673eaa1776d020d828713753f18fa5dd6a268195fef"
  head "https://github.com/MLton/mlton.git"

  bottle do
    cellar :any
    sha256 "33373d7c0a3798f61df7617d896e5a57adad6c0fd5b0183acc55ce1fc6db1f76" => :high_sierra
    sha256 "cc534218ef56b8debc2c391821753433303698c3299a663ff0cac9af03f71ac5" => :sierra
    sha256 "97656e7b1533886252d034c4a6ac0391d386369598f36a72a0033df8bc54a339" => :el_capitan
    sha256 "96fb444b34e8a605445567482a480fb59be749f5f57f46bc704f44b4763f26ae" => :yosemite
    sha256 "fb9c2fbc7e1e0e975ef79a061d17d56b8300da5a60c4b347e6726966c30f8fc3" => :mavericks
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
