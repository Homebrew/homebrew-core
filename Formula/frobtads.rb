class Frobtads < Formula
  desc "TADS interpreter and compilers"
  homepage "http://www.tads.org/frobtads.htm"
  url "https://github.com/realnc/frobtads/releases/download/1.2.4/frobtads-1.2.4.tar.bz2"
  sha256 "705be5849293844f499a85280e793941b0eacb362b90d49d85ae8308e4c5b63c"

  bottle do
    rebuild 1
    sha256 "bee493bbabeae1390a581f8e949db51c98facef463ea4cbb4e92cb096cf77339" => :high_sierra
    sha256 "8bc8bce88594b63897623bd11ac5e91fe37cde7608935cb17c93676f30a74109" => :sierra
    sha256 "9eff8f1df1176294c2fedbbc90c269a1b1d38e794265c0a48289bb9a2eab77dc" => :el_capitan
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /FrobTADS #{version}$/, shell_output("#{bin}/frob --version")
  end
end
