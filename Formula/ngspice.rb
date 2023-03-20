class Ngspice < Formula
  desc "Spice circuit simulator"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/39/ngspice-39.tar.gz"
  sha256 "b89c6bbce6e82ca9370b7f5584c9a608b625a7ed25e754758c378a6fb7107925"
  license :cannot_represent

  livecheck do
    url :stable
    regex(%r{url=.*?/ngspice[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 arm64_ventura:  "366f2cd42e46311860fe64751d20d95183cd6f860b47515fb414e82a7cbfb545"
    sha256 arm64_monterey: "9680cc44818f6fa4bff8b40c7127297465563fad677a8fcbba362376988c857a"
    sha256 arm64_big_sur:  "b0eae6aaa425e389623514de7e42c66d45689fc9db49662da2fea002a73863e2"
    sha256 ventura:        "ee0f1e1bec2082114c6c62a89ae546b86eb62438655936f57f94ee4ff0ccf401"
    sha256 monterey:       "9ae02cb9eb15ec5051afc935a0a25edbef1359d6042ac66472ffecbb0175a0ae"
    sha256 big_sur:        "904aed2d51bd6024da7d2badff4c297e0eaa8c683b7e0195512de7711742b38d"
    sha256 x86_64_linux:   "d06b2b21e8e90f7b447ab60fc85f2368fec37758d68c56d2d3ce49b208293028"
  end

  head do
    url "https://git.code.sf.net/p/ngspice/ngspice.git", branch: "master"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "bison" => :build
  depends_on "libtool" => :build
  depends_on "fftw"
  depends_on "libngspice"
  depends_on "readline"

  def install
    system "./autogen.sh"

    args = %w[
      --with-readline=yes
      --enable-xspice
      --without-x
    ]

    system "./configure", *std_configure_args, *args
    system "make", "install"

    # fix references to libs
    inreplace pkgshare/"scripts/spinit", lib/"ngspice/", Formula["libngspice"].opt_lib/"ngspice/"

    # remove conflict lib files with libngspice
    rm_rf Dir[lib/"ngspice"]
  end

  test do
    (testpath/"test.cir").write <<~EOS
      RC test circuit
      v1 1 0 1
      r1 1 2 1
      c1 2 0 1 ic=0
      .tran 100u 100m uic
      .control
      run
      quit
      .endc
      .end
    EOS
    system "#{bin}/ngspice", "test.cir"
  end
end
