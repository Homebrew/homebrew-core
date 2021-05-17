class Hamlib < Formula
  desc "Ham radio control libraries"
  homepage "http://www.hamlib.org/"
  url "https://github.com/Hamlib/Hamlib/releases/download/4.2/hamlib-4.2.tar.gz"
  sha256 "e200b22f307e9a0c826187c2b08fe81c7d0283cf07056e6db3463d1481580fd5"
  license "LGPL-2.1-or-later"
  head "https://github.com/hamlib/hamlib.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "69ca3e44a728006591fbfd52e8941f630b60a5f78491f5c7a7b00e73d5c09d3a"
    sha256 cellar: :any, big_sur:       "9ceda629c590e4f94150d19b65d41ad60692c36e95a15f3a402a7b77b77264ec"
    sha256 cellar: :any, catalina:      "8438ca728e483627d35c770a76a07d814336e469619e1b7f9baa3f8a3659d0cf"
    sha256 cellar: :any, mojave:        "af9e82439e617309d3d5f979347d0ffd5c3b65768ffc5f93f8031fd74ee71178"
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
