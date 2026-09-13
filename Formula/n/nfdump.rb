class Nfdump < Formula
  desc "Tools to collect and process netflow data on the command-line"
  homepage "https://github.com/phaag/nfdump"
  url "https://github.com/phaag/nfdump/archive/refs/tags/v1.7.10.tar.gz"
  sha256 "9a1bc84eb484c7383eea3b48ad2abe5b9ffe7e90aab3fda7055aa3f64be0cc29"
  license "BSD-3-Clause"
  head "https://github.com/phaag/nfdump.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "e503d3f84145d4f523be259654eb0aebc9259a36c9c7880d743dc2f987d2e38f"
    sha256 cellar: :any, arm64_tahoe:       "8af6ec9421617e7dfb41fd2a8dcddc9221221896cd96b4bd09a2ba6e06efb2a4"
    sha256 cellar: :any, arm64_sequoia:     "d929d7c54ab4f3f60b5959e3ffd9fb45675ede6741ec323f36126889d6ac8df5"
    sha256 cellar: :any, arm64_linux:       "79b9079e2ee58183189bb647f56d5195e475b8123a631c72f84c1317b5470f32"
    sha256 cellar: :any, x86_64_linux:      "76f14a3855d1205cc9be006866a7ed53d4dcb9b7313a9e3f724e83bee408ab14"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "bzip2"
  uses_from_macos "libpcap"

  on_linux do
    depends_on "libbsd"
  end

  def install
    # FIXME: the macOS 27 SDK `fts.h` includes `<fts_compat.h>`, which resolves to the bundled
    # `src/libnffile/fts_compat.h` instead, so build the bundled fts implementation there
    ENV["ac_cv_header_fts_h"] = "no" if OS.mac? && MacOS.version >= :golden_gate

    system "./autogen.sh"
    system "./configure", "--enable-readpcap", "LEXLIB=", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"nfdump", "-Z", "host 8.8.8.8"
  end
end
