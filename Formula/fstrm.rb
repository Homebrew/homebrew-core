class Fstrm < Formula
  desc "Frame Streams implementation in C"
  homepage "https://github.com/farsightsec/fstrm"

  url "https://dl.farsightsecurity.com/dist/fstrm/fstrm-0.3.2.tar.gz"
  sha256 "2d509999ac904e48c038f88820f47859da85ceb86c06552e4052897082423ec5"

  bottle do
    cellar :any
    sha256 "fb7031a0e06d718a7d345ab21796b0f9b6da6ebf411d24b1f019ba3e526dbfdc" => :sierra
    sha256 "45d2c965a757c50c5b65d929082baeedd045a7794eb933618e10a4371cfc0d90" => :el_capitan
    sha256 "36ec0bf5368fd0bbcfe7b14302b003f543ef4365fe458d2975998993b2b1f0d8" => :yosemite
  end

  head do
    url "https://github.com/farsightsec/fstrm.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
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
    system "sh", "-c", "#{bin}/fstrm_capture -t protobuf:dnstap.Dnstap -u dnstap.sock -w capture.fstrm -dddd & sleep 1; kill $!"
    system "#{bin}/fstrm_dump", "capture.fstrm"
  end
end
