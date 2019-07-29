class Plustache < Formula
  desc "C++ port of Mustache templating system"
  homepage "https://github.com/mrtazz/plustache"
  url "https://github.com/mrtazz/plustache/archive/0.4.0.tar.gz"
  sha256 "83960c412a7c176664c48ba4d718e72b5d39935b24dc13d7b0f0840b98b06824"

  bottle do
    cellar :any
    sha256 "853b1c9c7d7f1c8cf8b7c6a1d0928a991b9c5646a326fe520d90a2cd28fc42dc" => :mojave
    sha256 "7be831bc5c4402d088a31cd3e3c55e9e0ae105d969eea9a676744b212bdbc446" => :high_sierra
    sha256 "5122ac5404ae416955c5f3b64b63bfd617a530e746194590d3779ae61710f281" => :sierra
    sha256 "d5a98c71ef6162127b0a9017a85e929effff39ce1d75318a75cfca93086ff922" => :el_capitan
    sha256 "71e6a72ee994c2cabe2639dcd030a2ee577c1ceced012027766e108812bf7505" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "boost"

  def install
    system "autoreconf", "--force", "--install"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
