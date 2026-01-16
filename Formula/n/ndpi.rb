class Ndpi < Formula
  desc "Deep Packet Inspection (DPI) library"
  homepage "https://www.ntop.org/products/deep-packet-inspection/ndpi/"
  url "https://github.com/ntop/nDPI/archive/refs/tags/5.0.tar.gz"
  sha256 "8b0d3dc0c8a6a68578e09a18c922021ef6458d4aca1c7a20ce04efc267aa9ea5"
  license "LGPL-3.0-or-later"
  head "https://github.com/ntop/nDPI.git", branch: "dev"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "e36d749ae34d4213e05001e200919c6d9c96f7efbd44cd9225408e8691eceaeb"
    sha256 cellar: :any,                 arm64_sequoia: "e62b6b4475ecf76666c907dd2902a12ecb340cc7dd313a65cffb273a456e8ff6"
    sha256 cellar: :any,                 arm64_sonoma:  "ab4a5be202edd011b4171201c66f5ef7df058874ca0eb579de47a5d5825d70dc"
    sha256 cellar: :any,                 sonoma:        "89b2916adee9e543900f7089ed517776a5943411817885121ae97153e1ed7a70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ab29c1a19ee2b0bf75071152e77ab23d0da4fd4a589a770bb7c2519710470755"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6a58d36dd8c1cef5dae9bf5edc5f395b12a9b9568c753a4f4487ade46863b9c5"
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
