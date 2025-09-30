class Bgpdump < Formula
  desc "C library for analyzing MRT/Zebra/Quagga dump files"
  homepage "https://github.com/RIPE-NCC/bgpdump/wiki"
  url "https://github.com/RIPE-NCC/bgpdump/archive/refs/tags/v1.6.2.tar.gz"
  sha256 "415692c173a84c48b1e927a6423a4f8fd3e6359bc3008c06b7702fe143a76223"
  license "GPL-2.0-only"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "e7f3f18e49653d1dff36e3ff2c608c0e20a387687655fa22c84b57fe015a431a"
    sha256 cellar: :any,                 arm64_sequoia:  "58a05ac326e701a6417482c33a5660c4cac2ad9a3995e64dd064bc088e9e8a8f"
    sha256 cellar: :any,                 arm64_sonoma:   "9845446b9c11faac51f1180ad9493fcc523ce44bc5f8179fd2ab4a985323e360"
    sha256 cellar: :any,                 arm64_ventura:  "7d108fc2cd142cecb17da960a4ec7db84bd63178879596c9f9811ce7caf6f015"
    sha256 cellar: :any,                 arm64_monterey: "d4fe975c315b68318f0c63ff6b0d4ab3d9c6477fde81f6a4feed97ebe0fc39e4"
    sha256 cellar: :any,                 arm64_big_sur:  "547aa3e0a48f992ab4475b4f4b9203d46700fbde8588528382a7fc730157235c"
    sha256 cellar: :any,                 sonoma:         "73a39e564b78ad124866c1c94468620723ff94abf20a314dcb8ac98d55a56367"
    sha256 cellar: :any,                 ventura:        "ae7e665b60cb17e22cd9a145c59f8e5fb1e847892376fe8a621249b67e5786b9"
    sha256 cellar: :any,                 monterey:       "946678f11f01a3b35808d48e2ee9dc92a54f400364c7ae20989cf64263d9ae0a"
    sha256 cellar: :any,                 big_sur:        "30a4765bc4c7decdb628df132d66bc675da867c5ed9631beac87dd99bce53713"
    sha256 cellar: :any,                 catalina:       "f7c93574ccb3a6eaa05910009e26068f99f14082df78d3b2b0b84166488657e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b47b8e9e6bf6cf650441e4ccf7127b058ce743716a6b83e06803e18f37d9c6ea"
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
