class Hamlib < Formula
  desc "Ham radio control libraries"
  homepage "http://www.hamlib.org/"
  url "https://github.com/Hamlib/Hamlib/releases/download/4.6.1/hamlib-4.6.1.tar.gz"
  sha256 "0822f59fdda0e40283eb55d94c64fc92e608ec9985414acae93d122fa83dacd4"
  license "LGPL-2.1-or-later"
  head "https://github.com/hamlib/hamlib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "3eae3a5652713e89b1ff7f10253283a0ff2f060cd6696a29746576a16febfe07"
    sha256 cellar: :any,                 arm64_sonoma:  "9107017dcaed5e7ca5b798d1be8ed741396b5abca0ef7de4b24349ef5bd7e45d"
    sha256 cellar: :any,                 arm64_ventura: "81b3adbc6c35758af9cfca5584cad884fa0f3482ec5dd3dc31aff0b349878518"
    sha256 cellar: :any,                 sonoma:        "391f4b49ac98fa5d5a0a371d60a166db594e212af4206a85cf676d1e222a8078"
    sha256 cellar: :any,                 ventura:       "699550dd2156086dbadbf43d7b1563b2508b1ce0e0a4471ae7f0358972578f1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73bd5d82926f140031e8ee51a83cd9dadf9fac353620277251fc2a02d7bacfb6"
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
