class Mlton < Formula
  desc "Whole-program, optimizing compiler for Standard ML"
  homepage "http://mlton.org"
  url "https://downloads.sourceforge.net/project/mlton/mlton/20210117/mlton-20210117.src.tgz"
  version "20210117"
  sha256 "ec7a5a54deb39c7c0fa746d17767752154e9cb94dbcf3d15b795083b3f0f154b"
  license "HPND"
  version_scheme 1
  head "https://github.com/MLton/mlton.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{url=.*?/mlton[._-]v?(\d+(?:\.\d+)*(?:-\d+)?)[._-]src\.t}i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "47153e8fe8add04e420f69b4d5b1062ac2fa9abc1106cda2e5d0d0893ed0ca79"
    sha256 cellar: :any,                 arm64_monterey: "b63990802ceb1eab45673ca135e32aa1329a051fdd2ac3ca28c703d691e2f854"
    sha256 cellar: :any,                 arm64_big_sur:  "13f277d7115052ab34efd1cbea436bb9dec5227a09cc1f1e7c07a9f0670f7405"
    sha256 cellar: :any,                 ventura:        "fbea833f5eb02f0c9a3ff0a0f494eae2dc24232672900deb1863de117d2b1904"
    sha256 cellar: :any,                 monterey:       "67242137af80b4ecae138c139ee1e169d8ee04a1928ae0e40cbd339c2846d349"
    sha256 cellar: :any,                 big_sur:        "1a78dc22f29209bd9d2b3acc9b4d67655443a07adda31e421ccd748ae82cf50d"
    sha256 cellar: :any,                 catalina:       "049702ba52a30d7d5e4f005f68e35460ed9a9f18cc2af5d1ae66ca6c2d8fd5e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8dd855cfe0427e16f22c83f52f19999fa184cbac12853431fac1444c34565ff4"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gmp"

  # The corresponding upstream binary release used to bootstrap.
  resource "bootstrap" do
    on_macos do
      # See https://projects.laas.fr/tina/howto-arm64-darwin.html and
      # https://projects.laas.fr/tina/software.php
      on_arm do
        url "https://projects.laas.fr/tina/software/mlton-20210117-1.arm64-darwin-21.6-gmp-static.tgz"
        sha256 "5d8cc4046f502ca7d98670d53915e3a1973ec0826e4c4c23e25d483fa657c1e8"
      end
      # https://github.com/Homebrew/homebrew-core/pull/58438#issuecomment-665375929
      # new `mlton-20210117-1.amd64-darwin-17.7.gmp-static.tgz` artifact
      # used here for bootstrapping all homebrew versions
      on_intel do
        url "https://downloads.sourceforge.net/project/mlton/mlton/20210117/mlton-20210117-1.amd64-darwin-19.6.gmp-static.tgz"
        sha256 "5bea9f60136ea6847890c5f4e45d7126a32ef14fd46a2303cab875ca95c8cd76"
      end
    end

    on_linux do
      url "https://downloads.sourceforge.net/project/mlton/mlton/20210117/mlton-20210117-1.amd64-linux-glibc2.23.tgz"
      sha256 "5ac30fe415dd9bf727327980391df2556fed3f8422e36624db1ce0e9f7fba1e5"
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
    args << "OLD_MLTON_COMPILE_ARGS=-link-opt '-no-pie'" if OS.linux?
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
