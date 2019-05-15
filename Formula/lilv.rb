class Lilv < Formula
  desc "C library to use LV2 plugins"
  homepage "https://drobilla.net/software/lilv/"
  url "https://download.drobilla.net/lilv-0.24.4.tar.bz2"
  sha256 "c33b84b7a6e8e8fffb412fbcd6f69e59ca297ef3e29d829249b4ccc94f634438"

  bottle do
    cellar :any
    sha256 "6b1d5e743fb5ea653a41df22339f5ec95e1ca906d2dbbdb726f4c37dac5980cb" => :mojave
    sha256 "3878a061cb63137874620567165c7ba656d3e27972486d3c795088bb98b83980" => :high_sierra
    sha256 "db6587400999d5febf3a2cad3f79c17b51537388b8eb8cebbc0e0751c545b763" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "lv2"
  depends_on "serd"
  depends_on "sord"
  depends_on "sratom"

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf"
    system "./waf", "install"
  end
end
