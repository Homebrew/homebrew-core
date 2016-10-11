class Cclive < Formula
  desc "Command-line video extraction utility"
  homepage "http://cclive.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/cclive/0.7/cclive-0.7.16.tar.xz"
  sha256 "586a120faddcfa16f5bb058b5c901f1659336c6fc85a0d3f1538882a44ee10e1"

  bottle do
    cellar :any
    sha256 "86960a17d3c2ccb689895407af5801d814fcf7ab7eef71139e28d06ac240a12e" => :sierra
    sha256 "ee97b1e9aed8607c31dc6e9689bb5230e0d114d993ff06cbfca55b3c5c3ea448" => :el_capitan
    sha256 "118ddf82fb54c2dc14e664328499faea71d5b516166244a6a179037cce16b8bc" => :yosemite
    sha256 "74168fac20d931d1b6e2c702ac5818188288271100c9e3f15245b63a1e27d9bc" => :mavericks
  end

  conflicts_with "clozure-cl", :because => "both install a ccl binary"

  depends_on "pkg-config" => :build
  depends_on "quvi"
  depends_on "boost"
  depends_on "pcre"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
