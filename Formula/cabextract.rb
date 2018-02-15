class Cabextract < Formula
  desc "Extract files from Microsoft cabinet files"
  homepage "https://www.cabextract.org.uk/"
  url "https://www.cabextract.org.uk/cabextract-1.6.tar.gz"
  sha256 "cee661b56555350d26943c5e127fc75dd290b7f75689d5ebc1f04957c4af55fb"

  bottle do
    cellar :any_skip_relocation
    sha256 "ddbd5454fc6d47066949775c746003a9bbb8156638fd35e046ae9ae6b9c2d8ac" => :high_sierra
    sha256 "71efac9941b5d7f345cca0cebd739c8d235f47585651a03260ff46b8c45a815d" => :sierra
    sha256 "c0346331ea9ab80aabaf9a74e06ab2f00b0898859e129583e8509a26d2ff7270" => :el_capitan
    sha256 "e86f3dda55d8cbba0602abacbf67d09a1b733d4fe6db761938f8a3416f1cf5a8" => :yosemite
    sha256 "f71f87d6bbb877207ad984d8ad4bd68c7f50ae0305178583c968847cb57f6179" => :mavericks
    sha256 "464d4ede11b2be5ecf25244193e901d9d08c1d0daf254204703e054405e41603" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # probably the smallest valid .cab file
    cab = <<~EOS.gsub(/\s+/, "")
      4d5343460000000046000000000000002c000000000000000301010001000000d20400003
      e00000001000000000000000000000000003246899d200061000000000000000000
    EOS
    (testpath/"test.cab").binwrite [cab].pack("H*")

    system "#{bin}/cabextract", "test.cab"
    assert_predicate testpath/"a", :exist?
  end
end
