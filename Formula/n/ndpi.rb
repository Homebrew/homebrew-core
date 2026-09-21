class Ndpi < Formula
  desc "Deep Packet Inspection (DPI) library"
  homepage "https://www.ntop.org/products/deep-packet-inspection/ndpi/"
  url "https://github.com/ntop/nDPI/archive/refs/tags/6.0.tar.gz"
  sha256 "21fc40cab5505942c0b21d9bbaf73e9adf8162ddfe782e4cd072cab855a2eda9"
  license "LGPL-3.0-or-later"
  compatibility_version 1
  head "https://github.com/ntop/nDPI.git", branch: "dev"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "06db5ee2b09c176040edca83d1e7ac2d32af4b87404393f43597588af38b11b7"
    sha256 cellar: :any, arm64_tahoe:       "cf86686ce0f370748f00b3de4919977761898452304852d66defdb96e89d05a4"
    sha256 cellar: :any, arm64_sequoia:     "6233e5f6ef60a52cae5b40b3c7f1f759bcf51e1ca7ed9cd5796565ac44eaf357"
    sha256 cellar: :any, arm64_sonoma:      "955dc0af7bc7fc4122aa13faa96dc1857354369b04756612571d085d16754852"
    sha256 cellar: :any, arm64_linux:       "45abcc1c8736ac87a95421ecd1ce1336c72c1bcba6a065a515790117086130a9"
    sha256 cellar: :any, x86_64_linux:      "c8041a6f78767ef9b790e460b007467270596a456d8119a48a9846bbf8deae5e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "json-c"

  uses_from_macos "libpcap"

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"ndpiReader", "-i", test_fixtures("test.pcap")
  end
end
