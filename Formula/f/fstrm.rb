class Fstrm < Formula
  desc "Frame Streams implementation in C"
  homepage "https://github.com/farsightsec/fstrm"
  license "MIT"

  stable do
    url "https://dl.farsightsecurity.com/dist/fstrm/fstrm-0.6.1.tar.gz"
    sha256 "bca4ac1e982a2d923ccd24cce2c98f4ceeed5009694430f73fc0dcebca8f098f"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  # GitHub release descriptions contain a link to the `stable` tarball.
  livecheck do
    url :head
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "7b3467f8c2db26584cb092d8d9c4fe769f459d6a015c7f935d335a885c996697"
    sha256 cellar: :any,                 arm64_sequoia:  "d33b95ae03b379e72f20439898cb8c87f896d2994783778803c7701d92a57998"
    sha256 cellar: :any,                 arm64_sonoma:   "b016547f64c4a39ea5c551314def723180ee3de352008aaf09d77eb2b76bd8d2"
    sha256 cellar: :any,                 arm64_ventura:  "ebb6daed2a3a732ef21027362600e71790574221dddfc45c7926fa31ac51d41f"
    sha256 cellar: :any,                 arm64_monterey: "9a6bc2f1e46b05c45ea8f0925f08781d22604e8bc5a77357ccd29f2d90070ca3"
    sha256 cellar: :any,                 arm64_big_sur:  "409e20e264b28337487a22ff762e8f7d1b4dc81bea1cd131c6d673a978d94e2f"
    sha256 cellar: :any,                 sonoma:         "57b1b65ca1b36c9f8148ad93acef81a17f1f638db752176beb53fb3aa0e34459"
    sha256 cellar: :any,                 ventura:        "2ce57432abdc248382c8d9c333455c1c8dfbfc1f00958a66e0fe9772acd7f891"
    sha256 cellar: :any,                 monterey:       "1e8daf8e57af116ffdcf7ada7a945181d3ef35d955f1631a8ed4e2c27ac8ebcb"
    sha256 cellar: :any,                 big_sur:        "32c20ee504e029088d36ee45177137411beed0aaaac76ce287810cec71d3eea9"
    sha256 cellar: :any,                 catalina:       "3b775d63b3594f2264b413184aad3fbb33990c07473e0db9db12c86bd0f19950"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "6b511dcdd149db9a62c58e4fc0cfb79c2c72defb16a5bad62d5295beb601a5e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a1db14f84679ffb80882a5a00b733e671f82242d2a338ce485e180b4f40f1a0"
  end

  head do
    url "https://github.com/farsightsec/fstrm.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libevent"

  def install
    system "autoreconf", "--force", "--install", "--verbose" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    job = spawn bin/"fstrm_capture", "-t", "protobuf:dnstap.Dnstap",
                                     "-u", "dnstap.sock", "-w", "capture.fstrm", "-dddd"
    sleep 2

    system bin/"fstrm_dump", "capture.fstrm"
  ensure
    Process.kill("TERM", job)
  end
end
