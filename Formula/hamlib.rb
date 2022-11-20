class Hamlib < Formula
  desc "Ham radio control libraries"
  homepage "http://www.hamlib.org/"
  url "https://github.com/Hamlib/Hamlib/releases/download/4.5/hamlib-4.5.tar.gz"
  sha256 "14a2ce76a647a75e71d8ccf1f16999a6708e84823d9f74137f2173fcee94ad52"
  license "LGPL-2.1-or-later"
  head "https://github.com/hamlib/hamlib.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d47cac5b99d62eec75c065cc90fbe1b52602d8b716ab4fa0ee2eb886fa91b253"
    sha256 cellar: :any,                 arm64_monterey: "b68f6f796fedc7943e577dab6341a56f4fc1db350358d1bea9e59d060b33b270"
    sha256 cellar: :any,                 arm64_big_sur:  "047c1d7655f92d77f49b81649910d74eabeabb8328c5525dca9e20341f0ed2ab"
    sha256 cellar: :any,                 ventura:        "3b6a73c312ce332a79dd4076ae75e85caab6da6c5b6c989d2810c40263bf7fd9"
    sha256 cellar: :any,                 monterey:       "a148f79b3bc6100d1368aa410f3836d787c5c5afdc267b0543cacd7a994b2a29"
    sha256 cellar: :any,                 big_sur:        "c2a384b63d3b293331654c5d6f47641fba926b88b9ffce2a266c76dffb2ae486"
    sha256 cellar: :any,                 catalina:       "c967e1bdf6ec12bf8284c1e24085d8966ce324f1a49a674ff0aeb92f3c4cae72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a951478fad1766716f5320d1f8e5199cf5c2ad4c1a8ed25e9b73f427a574f3c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool"
  depends_on "libusb-compat"

  fails_with gcc: "5"

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/rigctl", "-V"
  end
end
