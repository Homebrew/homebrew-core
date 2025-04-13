class Hamlib < Formula
  desc "Ham radio control libraries"
  homepage "http://www.hamlib.org/"
  url "https://github.com/Hamlib/Hamlib/releases/download/4.6.2/hamlib-4.6.2.tar.gz"
  sha256 "b2ac73f44dd1161e95fdee6c95276144757647bf92d7fdb369ee2fe41ed47ae8"
  license "LGPL-2.1-or-later"
  head "https://github.com/hamlib/hamlib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9167a0022aa4c469cc54b917d0f4eccb1df3a8dd16c2bde575939a9bb363053f"
    sha256 cellar: :any,                 arm64_sonoma:  "c4aa54f5b84ad20d5378a77c1860de8ef5307a36e2ba4d44252c3236115e7f68"
    sha256 cellar: :any,                 arm64_ventura: "29ca12dd53120b6219a72cf06003ac4f9f7b0136d3a906f2f7c7e283a677ad27"
    sha256 cellar: :any,                 sonoma:        "6e018327f7f25dc3826e923f7e1aff7c45f20a90a5682b9359f78d548b33e610"
    sha256 cellar: :any,                 ventura:       "49b659bd45a24723430fc33d608f8bbd247678183a9f67e7cf2ff95d6344fc96"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd26f0e428ccfdf1090ce0a9ad4ea786949d88b3399e384084f5722dac54b877"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39cd33fc06e7145cca060ed370d7c6b099dcd87eba63947403f947d9eac2d1a0"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build
  depends_on "libtool"
  depends_on "libusb"
  depends_on "libusb-compat"

  on_linux do
    depends_on "readline"
  end

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"rigctl", "-V"
  end
end
