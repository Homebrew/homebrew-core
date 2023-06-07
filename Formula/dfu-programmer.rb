class DfuProgrammer < Formula
  desc "Device firmware update based USB programmer for Atmel chips"
  homepage "https://github.com/dfu-programmer/dfu-programmer"
  url "https://github.com/dfu-programmer/dfu-programmer/releases/download/v1.0.0/dfu-programmer-1.0.0.tar.gz"
  sha256 "867eaf0a8cd10123715491807ab99cecb54dc6f09dddade4b2a42b0b0ef9e6b0"
  license "GPL-2.0-or-later"
  head "https://github.com/dfu-programmer/dfu-programmer.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0ee3ca7e532f5126a3057d13a2939e1f0232d7b6cff2af0672f53d6144e8f6e2"
    sha256 cellar: :any,                 arm64_monterey: "f3a7bfb62e5abdbc2a203c64e9e77aeb8789f26c415cf5522ea9a45e4ae22ecd"
    sha256 cellar: :any,                 arm64_big_sur:  "14c428f492b1d9e518d03286f7de7e6832c3d78fa617e00feec64835c9d8d3e4"
    sha256 cellar: :any,                 ventura:        "56efa5c602b0761a736298e90c54f91d4dc52773c15a83c8eb53a9f23469ae56"
    sha256 cellar: :any,                 monterey:       "472b84de78e5cf31a0c1895b7d77b7629b2dd89d8e3e8ae19e2725df5bdd4c8f"
    sha256 cellar: :any,                 big_sur:        "c6420d795445cfb417146574295c444dff81341a1fcaf1c590ffdffbf5a5287c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78a9f9e411887f156b843a85b6c29a251ef4addbec348b117de927e976b2bd9b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libusb-compat"

  def install
    system "./bootstrap.sh"
    system "./configure", *std_configure_args,
                          "--disable-libusb_1_0"
    system "make", "install"
  end

  test do
    system bin/"dfu-programmer", "--targets"
  end
end
