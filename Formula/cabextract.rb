class Cabextract < Formula
  desc "Extract files from Microsoft cabinet files"
  homepage "https://www.cabextract.org.uk/"
  url "https://www.cabextract.org.uk/cabextract-1.9.tar.gz"
  sha256 "1bbc793d83c73288acd7e28ce33ec04955a76c73bf6471424ff835d725fcc4c1"

  bottle do
    cellar :any_skip_relocation
    sha256 "2b5dcbad4ce24c5debc85c2be62441de02a1344212b6e09e346128150be60cd2" => :mojave
    sha256 "f21c7ec553310281e57747bdf83cf5ea354ffc2dbd5f832e4ec4fcce52ddaa6d" => :high_sierra
    sha256 "97075ab9f0784e98476a3f93049bd90f228e3cbd5cbae3bd6c89407a2878bd0a" => :sierra
    sha256 "334776a65d21dcec7002177408ebd2dd7116a707d78d74429add1cb9cc515705" => :el_capitan
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
