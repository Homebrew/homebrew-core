class Fstrm < Formula
  desc "Frame Streams implementation in C"
  homepage "https://github.com/farsightsec/fstrm"
  url "https://dl.farsightsecurity.com/dist/fstrm/fstrm-0.5.0.tar.gz"
  sha256 "10ee7792a86face1d2271dc591652ab8c7af6976883887c69fdb11f10da135fc"
  revision 1

  bottle do
    cellar :any
    sha256 "3dd80be760c39df81e083f3e7b1a8fd00d65aada1d3bb43bb2af66fc1ab47bcf" => :mojave
    sha256 "b6e66ea781aba5fc3b2aafb0b895d5e8ac24f57de5fbc99d32c0947b36fd4e6d" => :high_sierra
    sha256 "0525efc611c5006c41ba7ab1355479b4078298fa21739cee38225df35aa91d56" => :sierra
  end

  head do
    url "https://github.com/farsightsec/fstrm.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"

  def install
    system "autoreconf", "-fvi" if build.head?
    system "./configure", "--disable-debug",
           "--disable-dependency-tracking",
           "--disable-silent-rules",
           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    job = fork do
      exec bin/"fstrm_capture", "-t", "protobuf:dnstap.Dnstap",
           "-u", "dnstap.sock", "-w", "capture.fstrm", "-dddd"
    end
    sleep 2
    Process.kill("TERM", job)
    system "#{bin}/fstrm_dump", "capture.fstrm"
  end
end
