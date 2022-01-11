class Ngspice < Formula
  desc "Spice circuit simulator"
  homepage "https://ngspice.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ngspice/ng-spice-rework/36/ngspice-36.tar.gz"
  sha256 "4f818287efba245341046635b757ae81f879549b326a4316b5f6e697aa517f8c"

  livecheck do
    url :stable
    regex(%r{url=.*?/ngspice[._-]v?(\d+(?:\.\d+)*)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "d9ede6e35d7f1ab796ec2c19e785359dfa19f14c1ee2f84c8a0e1af5d6a138f0"
    sha256 arm64_big_sur:  "8107e3a0dbb732b3da2e9b4f0dc7115f147c4df5203d2740cf356530414fbaa1"
    sha256 monterey:       "8f9f6742807f18fedd725bd51d09cf4fbfce072a4646d03ff96839935326acbb"
    sha256 big_sur:        "06e7103236e3bf1aa3037c25a2b47a916574677632749c4fc461d6ddfd976470"
    sha256 catalina:       "857b80d8491645039822df8c422a662667501295598b4c89c63e573b31fc0aea"
    sha256 x86_64_linux:   "777b72adb972fd06b5456835016d6625a45f6bc9473792c6e013eb3765b4254f"
  end

  head do
    url "https://git.code.sf.net/p/ngspice/ngspice.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "bison" => :build
    depends_on "libtool" => :build
  end

  depends_on "fftw"
  depends_on "readline"

  def install
    system "./autogen.sh" if build.head?

    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --with-readline=yes
      --enable-xspice
      --without-x
    ]

    system "./configure", *args
    system "make", "install"

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
