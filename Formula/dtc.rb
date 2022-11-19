class Dtc < Formula
  desc "Device tree compiler"
  homepage "https://www.devicetree.org/"
  url "https://www.kernel.org/pub/software/utils/dtc/dtc-1.6.1.tar.xz"
  sha256 "65cec529893659a49a89740bb362f507a3b94fc8cd791e76a8d6a2b6f3203473"
  license any_of: ["GPL-2.0-or-later", "BSD-2-Clause"]

  livecheck do
    url "https://mirrors.edge.kernel.org/pub/software/utils/dtc/"
    regex(/href=.*?dtc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "b2bbb6606b24abfdb46d7a7276e1c5505398ca38e21aeefcd2dd1b05fd6b37a2"
    sha256 cellar: :any,                 arm64_monterey: "8a4fa796ccb2287c99895a475294ad882109f67ade30b0a065841fbf479623df"
    sha256 cellar: :any,                 arm64_big_sur:  "168a39095510690ae8762826e1333a96b526e1124593449724cb932458fcefc9"
    sha256 cellar: :any,                 ventura:        "637691691a6eb56e4549dd5684e65488fc4ed853d84a3a2e848d1d19acbe756b"
    sha256 cellar: :any,                 monterey:       "077453035968d846c52b61c2d159b03031884a5442a04a1375bbbb01f426e18b"
    sha256 cellar: :any,                 big_sur:        "dabe49f9ad4701b06c1954ac168c633b8ca9a5a8639302d75264640d5df4be49"
    sha256 cellar: :any,                 catalina:       "9eef250847cc0a60cafb5b8f54d217f297568ba5297c99bda43c14b6fbc4fa45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dc713c8397ab10c889bda1e8e8188569adb8928f9cce53b5ea7ca155bcb19f54"
  end

  depends_on "pkg-config" => :build

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    inreplace "libfdt/Makefile.libfdt", "libfdt.$(SHAREDLIB_EXT).1", "libfdt.1.$(SHAREDLIB_EXT)" if OS.mac?
    system "make", "NO_PYTHON=1"
    system "make", "NO_PYTHON=1", "DESTDIR=#{prefix}", "PREFIX=", "install"
  end

  test do
    (testpath/"test.dts").write <<~EOS
      /dts-v1/;
      / {
      };
    EOS
    system "#{bin}/dtc", "test.dts"
  end
end
