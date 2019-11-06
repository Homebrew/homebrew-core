class Libmonome < Formula
  desc "Interact with monome devices via C, Python, or FFI"
  homepage "https://monome.org/"
  url "https://github.com/monome/libmonome/archive/v1.4.2.tar.gz"
  sha256 "d8f87fc8240214c2ca433f4b185eb3ddbace2065f95487e5d9ac0ab60220393d"
  head "https://github.com/monome/libmonome.git"

  bottle do
    cellar :any
    rebuild 2
    sha256 "2f50af40811f13ee3dc2a372c98a3efa413d55a311093c1e34a9fabedda624e0" => :catalina
    sha256 "edd05ad00d159e4cb6ff44306d94e981891a2009999706700f614f4127feeef8" => :mojave
    sha256 "c99ff2d00d681cc2ea502023119bd29453000920142709fa6927259a2dca9584" => :high_sierra
  end

  depends_on "liblo"

  def install
    # Fix build on Mojave
    # https://github.com/monome/libmonome/issues/62
    inreplace "wscript", /conf.env.append_unique.*-mmacosx-version-min=10.5.*/,
                         "pass"

    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"
  end
end
