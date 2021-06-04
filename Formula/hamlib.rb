class Hamlib < Formula
  desc "Ham radio control libraries"
  homepage "http://www.hamlib.org/"
  url "https://github.com/Hamlib/Hamlib/releases/download/4.2/hamlib-4.2.tar.gz"
  sha256 "e200b22f307e9a0c826187c2b08fe81c7d0283cf07056e6db3463d1481580fd5"
  license "LGPL-2.1-or-later"
  head "https://github.com/hamlib/hamlib.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "c7dfb2164dc7bbe147c948b265d944e2a41c9ab9f294214bc9165b7ad4614537"
    sha256 cellar: :any, big_sur:       "f1fa8a3f93559bbbd1ad1b755f8eb2ce5921b92fef9f518272bc6899839598d9"
    sha256 cellar: :any, catalina:      "ac504c6406287a191b5a2f1db43825834565d3c6449dbe2c53223dac7a852710"
    sha256 cellar: :any, mojave:        "b13365794825287c71d659ef7314e3321c7123b0451e68b34fb1995292a8ee6a"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool"
  depends_on "libusb-compat"

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
