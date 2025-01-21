class Hamlib < Formula
  desc "Ham radio control libraries"
  homepage "http://www.hamlib.org/"
  url "https://github.com/Hamlib/Hamlib/releases/download/4.6/hamlib-4.6.tar.gz"
  sha256 "6f873579bc4e0ef4e540313ec2acd4f198b5510d7dd9397a4ae68fe8ff20d167"
  license "LGPL-2.1-or-later"
  head "https://github.com/hamlib/hamlib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "fef2669dbd14b7eb9444d67dd07b583a24c642b93534cf98e658c68af205a9e4"
    sha256 cellar: :any,                 arm64_sonoma:  "63b00a950e4834bb234bee5426560f20384adbc93b0ef4357e4df48878aa3af6"
    sha256 cellar: :any,                 arm64_ventura: "9bca5b206f7b1bbad714cfa9631ec0054605daa8404ae7bb01b7096fb62e417a"
    sha256 cellar: :any,                 sonoma:        "e6bd7ffb646a0bc46604ea968ec770d38641d1e6da613697ba75168f25062673"
    sha256 cellar: :any,                 ventura:       "7ef8078221bd4b158f38d83c6e41240e0ae9d7c9b02e3d5b1ce2bb8319fb6401"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a71ffe4636052758942c819463e3af382e1de91c9b1d58fbe899734dc845947"
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
