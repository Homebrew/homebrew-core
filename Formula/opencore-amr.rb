class OpencoreAmr < Formula
  desc "Audio codecs extracted from Android open source project"
  homepage "https://opencore-amr.sourceforge.io/"
  url "https://downloads.sourceforge.net/opencore-amr/opencore-amr-0.1.5.tar.gz"
  sha256 "2c006cb9d5f651bfb5e60156dbff6af3c9d35c7bbcc9015308c0aff1e14cd341"

  bottle do
    cellar :any
    sha256 "424d294d95aa7539842f1c2402a0be6ba558fa22680a0f5681998b12cf45a152" => :catalina
    sha256 "816d5463797b6412fd8944b98ab79d766dcf886b9eb37d83778fb7648d995603" => :mojave
    sha256 "5f5f7853d97b957abb8671af372bd3a4a13191ccd135799cbad44aa3c66034ec" => :high_sierra
    sha256 "2b6378d4427dc88bac7e01d2614dd100535f1d78b1e6b81560e3a074e1d5a770" => :sierra
    sha256 "4b628ad01f725342698a8556c4176f5d57e3647cc0f52669092a0523b76cc5d0" => :el_capitan
    sha256 "0e8940ad28407b353c69b7fa0cdcd7d90777345f5ea86dcc9974552f99c1030c" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
