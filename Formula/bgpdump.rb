class Bgpdump < Formula
  desc "C library for analyzing MRT/Zebra/Quagga dump files"
  homepage "https://github.com/RIPE-NCC/bgpdump/wiki"
  url "https://github.com/RIPE-NCC/bgpdump/archive/v1.6.2.tar.gz"
  sha256 "415692c173a84c48b1e927a6423a4f8fd3e6359bc3008c06b7702fe143a76223"
  license "GPL-2.0"

  livecheck do
    url "https://github.com/RIPE-NCC/bgpdump.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    cellar :any
    sha256 "30a4765bc4c7decdb628df132d66bc675da867c5ed9631beac87dd99bce53713" => :big_sur
    sha256 "547aa3e0a48f992ab4475b4f4b9203d46700fbde8588528382a7fc730157235c" => :arm64_big_sur
    sha256 "f7c93574ccb3a6eaa05910009e26068f99f14082df78d3b2b0b84166488657e5" => :catalina
    sha256 "271ccd88799103255a673c6eafba9ec39320a8eb1a5a80bc8eef25ec508c31a6" => :mojave
    sha256 "441599b105e925cf6875f3e1d1a380cf94ec1069b214872173cd08736cd8671c" => :high_sierra
  end

  depends_on "autoconf" => :build

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/bgpdump", "-T"
  end
end
