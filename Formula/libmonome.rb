class Libmonome < Formula
  desc "Interact with monome devices via C, Python, or FFI"
  homepage "https://monome.org/"
  url "https://github.com/monome/libmonome/archive/v1.4.2.tar.gz"
  sha256 "d8f87fc8240214c2ca433f4b185eb3ddbace2065f95487e5d9ac0ab60220393d"
  head "https://github.com/monome/libmonome.git"

  bottle do
    rebuild 1
    sha256 "496bbe0ff03f836144608b616509b55d0364f6fa0db2ced6b925faece6968db1" => :mojave
    sha256 "2164a28b7e64a3f1b5e982c284a1ee054a4cdf18cfbac519c4137b09135f3ca9" => :high_sierra
    sha256 "69faca4fa799289da9b5504c9b6aea230771c90a243e69e733307bd97e1dd71d" => :sierra
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
