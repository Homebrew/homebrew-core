class DfuUtil < Formula
  desc "USB programmer"
  homepage "https://dfu-util.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/dfu-util/dfu-util-0.11.tar.gz"
  sha256 "b4b53ba21a82ef7e3d4c47df2952adf5fa494f499b6b0b57c58c5d04ae8ff19e"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "53e343420fcab5133dd295cf75d8a74b5933fabfbb53c90c3ef798735b5f9445"
    sha256 cellar: :any,                 arm64_sequoia:  "5cfdae94eea7b66aae31b16dd689bd8078d7aa685786dcf45f9f9324db12727d"
    sha256 cellar: :any,                 arm64_sonoma:   "948497e1bb1a0f035517671d50e3d64c8843417210acb3cdc16232884399c783"
    sha256 cellar: :any,                 arm64_ventura:  "03e81fc129ada62759e3cd8d892131ca326851ab6631730e9d101405c0e2594d"
    sha256 cellar: :any,                 arm64_monterey: "7d09c40c797df76fdea2862b205111fa9c14d44b09c27a0b00e083fcc827bee9"
    sha256 cellar: :any,                 arm64_big_sur:  "c7dd53f422003b99c57f565aad8371e8cef1aa3de825f36cd927cd61ed64249d"
    sha256 cellar: :any,                 sonoma:         "ec1b2eb46336cab4cac68f413d2e0dd9b1af2fd63182598ca40f4dd61595efb9"
    sha256 cellar: :any,                 ventura:        "84abd91cd4595f7d3445b7d3ba754528fdb671c7cfcdf82977b96e701c0cf60e"
    sha256 cellar: :any,                 monterey:       "5daf11ce553e067f293fc615889d22c74abb9ea9da21f57699c81d65ee9fa089"
    sha256 cellar: :any,                 big_sur:        "b970a649e90f3e080af2143e8479e0616959e35650defea16b96288c4af011dc"
    sha256 cellar: :any,                 catalina:       "5a5d86794a00b9559ffc819715c297da4f477296d20a92c804aefc426795d0b0"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "228012ba20956504016ab24f43cec35ce3a6ca2d5da694072ef1f64b33b8203f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13c26d1ebc67dd60446845d51e3ff92bcded0ae223852dc104e897c8c3423f71"
  end

  head do
    url "https://git.code.sf.net/p/dfu-util/dfu-util.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkgconf" => :build
  depends_on "libusb"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"dfu-util", "-V"
    system bin/"dfu-prefix", "-V"
    system bin/"dfu-suffix", "-V"
  end
end
