class Iperf3 < Formula
  desc "Update of iperf: measures TCP, UDP, and SCTP bandwidth"
  homepage "https://github.com/esnet/iperf"
  url "https://github.com/esnet/iperf/archive/3.7.tar.gz"
  sha256 "c349924a777e8f0a70612b765e26b8b94cc4a97cc21a80ed260f65e9823c8fc5"

  bottle do
    cellar :any
    sha256 "d6a381921181af24ea39ea794ec5cf10fa212d7895c64d80c87f32f8ea863be1" => :mojave
    sha256 "73d711b5d84ff8f9e7a5f627f347d2c3d9917a646334505333442db64f3896e6" => :high_sierra
    sha256 "c5b5f9c38d7ae79b42cccfd1f7e5e0d4dd3f4586b6d655d319d4e3790040e55e" => :sierra
    sha256 "e9ec78eacf763a0b5e5ede66ca6caf5f56fa7df1fd07ad8e679808b933c88894" => :el_capitan
  end

  head do
    url "https://github.com/esnet/iperf.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl"

  def install
    system "./bootstrap.sh" if build.head?
    system "./configure", "--prefix=#{prefix}",
                          "--with-openssl=#{Formula["openssl"].opt_prefix}"
    system "make", "clean" # there are pre-compiled files in the tarball
    system "make", "install"
  end

  test do
    begin
      server = IO.popen("#{bin}/iperf3 --server")
      sleep 1
      assert_match "Bitrate", pipe_output("#{bin}/iperf3 --client 127.0.0.1 --time 1")
    ensure
      Process.kill("SIGINT", server.pid)
      Process.wait(server.pid)
    end
  end
end
