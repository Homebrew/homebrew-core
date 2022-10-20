class Ganglia < Formula
  desc "Scalable distributed monitoring system"
  homepage "https://ganglia.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ganglia/ganglia%20monitoring%20core/3.7.2/ganglia-3.7.2.tar.gz"
  sha256 "042dbcaf580a661b55ae4d9f9b3566230b2232169a0898e91a797a4c61888409"
  license "BSD-3-Clause"
  revision 3

  livecheck do
    url :stable
    regex(%r{url=.*?/ganglia[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_monterey: "ce6708001f5729b36e2a366a5569357598e0e1d0809e41cc3b637ceafd4eb154"
    sha256 arm64_big_sur:  "a988e988b2b539eeffaa6b6d01ebfa7748615c822daaee1cf617a606e900683e"
    sha256 monterey:       "b52de8c622a7bc483b5dfbf36f8b1c43050a478837058b41508dcf5346b16adb"
    sha256 big_sur:        "31b343fa942e30bddbbc737be768225774b0e7c182e278f85e16cd1b8b9d626e"
    sha256 catalina:       "3201c7b103ad74ed63d7e4cda74da894a3e71443a8b2e79353dcf22874580c96"
    sha256 mojave:         "ff01d1a7d5457e2572273e61463a7a9c0da1b8a6c12a998b4c4da157163110c8"
    sha256 high_sierra:    "d375f0a7bc5caff2ff825ac487530b0e78efb1521b8ea2b4ef7f15a002526941"
    sha256 sierra:         "c295e711dd78ca5a19e3b7f8c5534b049217664701c13312795bf035a3db2017"
    sha256 el_capitan:     "e2fe6f3370fa84645ff858ef651b54aee84b0522a8da0e529d6a98c465d6c8ad"
    sha256 x86_64_linux:   "d4511cf41a371373ca7123e601d57fad124778f93b26cff9697b2644514af9a9"
  end

  head do
    url "https://github.com/ganglia/monitor-core.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "apr"
  depends_on "confuse"
  depends_on "pcre"
  depends_on "rrdtool"

  conflicts_with "coreutils", because: "both install `gstat` binaries"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    if build.head?
      inreplace "bootstrap", "libtoolize", "glibtoolize"
      inreplace "libmetrics/bootstrap", "libtoolize", "glibtoolize"
      system "./bootstrap"
    end

    inreplace "configure", 'varstatedir="/var/lib"', %Q(varstatedir="#{var}/lib")
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--sysconfdir=#{etc}",
                          "--mandir=#{man}",
                          "--with-gmetad",
                          "--with-libapr=#{Formula["apr"].opt_bin}/apr-1-config",
                          "--with-libpcre=#{Formula["pcre"].opt_prefix}"
    system "make", "install"

    # Generate the default config file
    system "#{bin}/gmond -t > #{etc}/gmond.conf" unless File.exist? "#{etc}/gmond.conf"
  end

  def post_install
    (var/"lib/ganglia/rrds").mkpath
  end

  def caveats
    <<~EOS
      If you didn't have a default config file, one was created here:
        #{etc}/gmond.conf
    EOS
  end

  test do
    pid = fork do
      exec bin/"gmetad", "--pid-file=#{testpath}/pid"
    end
    sleep 30
    assert_predicate testpath/"pid", :exist?
  ensure
    Process.kill "TERM", pid
    Process.wait pid
  end
end
