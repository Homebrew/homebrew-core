class Frobtads < Formula
  desc "TADS interpreter and compilers"
  homepage "http://www.tads.org/frobtads.htm"
  url "http://www.tads.org/frobtads/frobtads-1.2.3.tar.gz"
  sha256 "88c6a987813d4be1420a1c697e99ecef4fa9dd9bc922be4acf5a3054967ee788"

  bottle do
    rebuild 1
    sha256 "bee493bbabeae1390a581f8e949db51c98facef463ea4cbb4e92cb096cf77339" => :high_sierra
    sha256 "8bc8bce88594b63897623bd11ac5e91fe37cde7608935cb17c93676f30a74109" => :sierra
    sha256 "9eff8f1df1176294c2fedbbc90c269a1b1d38e794265c0a48289bb9a2eab77dc" => :el_capitan
  end

  def install
    # Fix compilation with Xcode 9
    # https://github.com/realnc/frobtads/pull/2
    inreplace "tads3/vmtz.cpp",
              "result->set(tcur > 0 ? tcur - 1 : tcur)",
              "result->set((intptr_t)tcur > 0 ? tcur - 1 : tcur)"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /FrobTADS #{version}$/, shell_output("#{bin}/frob --version")
  end
end
