class Ganglia < Formula
  desc "Scalable distributed monitoring system"
  homepage "http://ganglia.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ganglia/ganglia%20monitoring%20core/3.7.1/ganglia-3.7.1.tar.gz"
  sha256 "e735a6218986a0ff77c737e5888426b103196c12dc2d679494ca9a4269ca69a3"
  revision 1

  bottle do
    sha256 "7b2b10090f35f813fdf1a5b715b4e2bba48bdf71a20fd0cd138be62a8f5aede2" => :el_capitan
    sha256 "05b2e1cef93776ddbf00c297efa272cd0fb99dcd8fe3e43a6732aa76d163d37f" => :yosemite
    sha256 "37813f22386432e9ed358cbf58b990570c31f7a989802da10da7524171654428" => :mavericks
  end

  head do
    url "https://github.com/ganglia/monitor-core.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  conflicts_with "coreutils", :because => "both install `gstat` binaries"

  depends_on "pkg-config" => :build
  depends_on :apr => :build
  depends_on "confuse"
  depends_on "pcre"
  depends_on "rrdtool"

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
