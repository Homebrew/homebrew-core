class Nfdump < Formula
  desc "Tools to collect and process netflow data on the command-line"
  homepage "https://github.com/phaag/nfdump"
  url "https://github.com/phaag/nfdump/archive/refs/tags/v1.7.10.tar.gz"
  sha256 "9a1bc84eb484c7383eea3b48ad2abe5b9ffe7e90aab3fda7055aa3f64be0cc29"
  license "BSD-3-Clause"
  head "https://github.com/phaag/nfdump.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "cc753b57106fbaae04829ed5505a8833db989ea54a8190e84dae771c72e0f1d7"
    sha256 cellar: :any, arm64_sequoia: "ff9fe8ecd2768f0c4b70bf5babf1d36c4812eca8dbf8c9d66ff14f33a0287ce0"
    sha256 cellar: :any, arm64_sonoma:  "34ad2b266dafad50419b6e2e3f03892764622ff2382e1ebf4a3238d6481ad1e6"
    sha256 cellar: :any, arm64_linux:   "af7cf0e4cc4fda5589ee0a36424cd4cc40c68a99a97b09c8c9f6d5b76f035bfb"
    sha256 cellar: :any, x86_64_linux:  "8dd0feb694c0a91bffd4637072dbb79255bb8486b35fb7ead8fb6459bd9ab0a7"
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
