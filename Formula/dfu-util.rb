class DfuUtil < Formula
  desc "USB programmer"
  homepage "https://dfu-util.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/dfu-util/dfu-util-0.11.tar.gz"
  sha256 "b4b53ba21a82ef7e3d4c47df2952adf5fa494f499b6b0b57c58c5d04ae8ff19e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "03e81fc129ada62759e3cd8d892131ca326851ab6631730e9d101405c0e2594d"
    sha256 cellar: :any,                 arm64_monterey: "7d09c40c797df76fdea2862b205111fa9c14d44b09c27a0b00e083fcc827bee9"
    sha256 cellar: :any,                 arm64_big_sur:  "c7dd53f422003b99c57f565aad8371e8cef1aa3de825f36cd927cd61ed64249d"
    sha256 cellar: :any,                 ventura:        "84abd91cd4595f7d3445b7d3ba754528fdb671c7cfcdf82977b96e701c0cf60e"
    sha256 cellar: :any,                 monterey:       "5daf11ce553e067f293fc615889d22c74abb9ea9da21f57699c81d65ee9fa089"
    sha256 cellar: :any,                 big_sur:        "b970a649e90f3e080af2143e8479e0616959e35650defea16b96288c4af011dc"
    sha256 cellar: :any,                 catalina:       "5a5d86794a00b9559ffc819715c297da4f477296d20a92c804aefc426795d0b0"
    sha256 cellar: :any,                 mojave:         "1ded847895f4d2a86a4a7754fa711014d09c334044ccc03aa97d89059ae58604"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13c26d1ebc67dd60446845d51e3ff92bcded0ae223852dc104e897c8c3423f71"
  end

  head do
    url "https://git.code.sf.net/p/dfu-util/dfu-util.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libusb"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"dfu-util", "-V"
    system bin/"dfu-prefix", "-V"
    system bin/"dfu-suffix", "-V"
  end
end
