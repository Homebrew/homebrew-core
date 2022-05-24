class Fstrm < Formula
  desc "Frame Streams implementation in C"
  homepage "https://github.com/farsightsec/fstrm"
  license "MIT"

  stable do
    url "https://dl.farsightsecurity.com/dist/fstrm/fstrm-0.6.1.tar.gz"
    sha256 "bca4ac1e982a2d923ccd24cce2c98f4ceeed5009694430f73fc0dcebca8f098f"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "9a6bc2f1e46b05c45ea8f0925f08781d22604e8bc5a77357ccd29f2d90070ca3"
    sha256 cellar: :any,                 arm64_big_sur:  "409e20e264b28337487a22ff762e8f7d1b4dc81bea1cd131c6d673a978d94e2f"
    sha256 cellar: :any,                 monterey:       "1e8daf8e57af116ffdcf7ada7a945181d3ef35d955f1631a8ed4e2c27ac8ebcb"
    sha256 cellar: :any,                 big_sur:        "32c20ee504e029088d36ee45177137411beed0aaaac76ce287810cec71d3eea9"
    sha256 cellar: :any,                 catalina:       "3b775d63b3594f2264b413184aad3fbb33990c07473e0db9db12c86bd0f19950"
    sha256 cellar: :any,                 mojave:         "7f18a4569511492fdad064427c67fc88f988046c1fc6804a7973e1ae2911714e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a1db14f84679ffb80882a5a00b733e671f82242d2a338ce485e180b4f40f1a0"
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
