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
    sha256 cellar: :any,                 arm64_monterey: "d4fe975c315b68318f0c63ff6b0d4ab3d9c6477fde81f6a4feed97ebe0fc39e4"
    sha256 cellar: :any,                 arm64_big_sur:  "547aa3e0a48f992ab4475b4f4b9203d46700fbde8588528382a7fc730157235c"
    sha256 cellar: :any,                 monterey:       "946678f11f01a3b35808d48e2ee9dc92a54f400364c7ae20989cf64263d9ae0a"
    sha256 cellar: :any,                 big_sur:        "30a4765bc4c7decdb628df132d66bc675da867c5ed9631beac87dd99bce53713"
    sha256 cellar: :any,                 catalina:       "f7c93574ccb3a6eaa05910009e26068f99f14082df78d3b2b0b84166488657e5"
    sha256 cellar: :any,                 mojave:         "271ccd88799103255a673c6eafba9ec39320a8eb1a5a80bc8eef25ec508c31a6"
    sha256 cellar: :any,                 high_sierra:    "441599b105e925cf6875f3e1d1a380cf94ec1069b214872173cd08736cd8671c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab69320eab97e440488a15664f3defe5f2dd921bedfd30c23b80deefc5c954e0"
  end

  depends_on "autoconf" => :build

  uses_from_macos "bzip2"
  uses_from_macos "zlib"

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
    system bin/"bgpdump", "-T"
  end
end
