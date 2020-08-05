class Ccd2iso < Formula
  desc "Convert CloneCD images to ISO images"
  homepage "https://ccd2iso.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/ccd2iso/ccd2iso/ccd2iso-0.3/ccd2iso-0.3.tar.gz"
  sha256 "f874b8fe26112db2cdb016d54a9f69cf286387fbd0c8a55882225f78e20700fc"

  bottle do
    cellar :any_skip_relocation
    sha256 "741bb587861701e9900ede511e2db1e73815428eb2f0f2c697313dad70609853" => :catalina
    sha256 "710ddc04aac005477e9aaa73e882bc1d8cbe96412ac949ff4a7501c6a53ca018" => :mojave
    sha256 "9d33b636be5f43c1e40955323c2f5d4a02d603c990aab2c89e98b5cb16a5cf93" => :high_sierra
    sha256 "c855496f0265a8f806228cddc1c15d5a1d6e7186f4bb43c0a317a6256d8e8e85" => :sierra
    sha256 "e74b2779ef3d832bc899422285c2d03ea33aa6ab979ca835914343999b444671" => :el_capitan
    sha256 "020f198fa4476dc640fa14e8efa7ad04985143e7007c45610b890bdc7db47599" => :yosemite
    sha256 "46facd34e7bbf203fe76dcd6e99bcf066eb245992aef01f1d703a9ce7a69cac3" => :mavericks
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match(
      /^#{Regexp.escape(version)}$/, shell_output("#{bin}/ccd2iso --version")
    )
  end
end
