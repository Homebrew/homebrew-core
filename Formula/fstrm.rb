class Fstrm < Formula
  desc "Frame Streams implementation in C"
  homepage "https://github.com/farsightsec/fstrm"
  url "https://dl.farsightsecurity.com/dist/fstrm/fstrm-0.4.0.tar.gz"
  sha256 "b20564cb2ebc7783a8383fbef5bcef5726f94baf48b83843553c9e1030b738ef"

  bottle do
    cellar :any
    sha256 "fae6f3f37c75a856fe12f497e3d706ca6a35f41585eb572fd6f1391aa4050170" => :mojave
    sha256 "b6c9ae4e8e88d65b3e7f2caac619b3aec15d6b50ed670a2a6cf61f2cab919ab7" => :high_sierra
    sha256 "c8b5b02ccac2d87c90cb33a686e428e1263c0ae19a2e6cf4847f0b7780110ee2" => :sierra
    sha256 "c18f60d06f6965bd0dbb7d063d61145461be190bad3503b693381d78a432c156" => :el_capitan
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
