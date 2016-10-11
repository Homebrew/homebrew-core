class Ganglia < Formula
  desc "Scalable distributed monitoring system"
  homepage "http://ganglia.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ganglia/ganglia%20monitoring%20core/3.7.1/ganglia-3.7.1.tar.gz"
  sha256 "e735a6218986a0ff77c737e5888426b103196c12dc2d679494ca9a4269ca69a3"
  revision 2

  bottle do
    sha256 "acdf779111e970a0109ee574e6b814b8378f29945d688bcb73a438e54d77ff9e" => :sierra
    sha256 "349f8c9d15380b37ab66eccba278a8f83537d4de091c76b1a699ea4c419131f7" => :el_capitan
    sha256 "e09a9d76d29124ed9c1b7c9f92d43a98a43f95be498d315296300a9bb487b980" => :yosemite
    sha256 "6aebfbaf3ebff825177eb2226d9a7d82f1543fd1ece8948eb6feea01f07b43e1" => :mavericks
  end

  head do
    url "https://github.com/ganglia/monitor-core.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on :apr => :build
  depends_on "confuse"
  depends_on "pcre"
  depends_on "rrdtool"

  conflicts_with "coreutils", :because => "both install `gstat` binaries"

  def install
    if build.head?
      inreplace "bootstrap", "libtoolize", "glibtoolize"
      inreplace "libmetrics/bootstrap", "libtoolize", "glibtoolize"
      system "./bootstrap"
    end

    inreplace "configure", %(varstatedir="/var/lib"), %(varstatedir="#{var}/lib")
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--sysconfdir=#{etc}",
                          "--mandir=#{man}",
                          "--with-gmetad",
                          "--with-libpcre=#{Formula["pcre"].opt_prefix}"
    system "make", "install"

    # Generate the default config file
    system "#{bin}/gmond -t > #{etc}/gmond.conf" unless File.exist? "#{etc}/gmond.conf"
  end

  def post_install
    (var/"lib/ganglia/rrds").mkpath
  end

  def caveats; <<-EOS.undent
    If you didn't have a default config file, one was created here:
      #{etc}/gmond.conf
    EOS
  end

  test do
    begin
      pid = fork do
        exec bin/"gmetad", "--pid-file=#{testpath}/pid"
      end
      sleep 2
      File.exist? testpath/"pid"
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
