class Ddate < Formula
  desc "Converts boring normal dates to fun Discordian Date"
  homepage "https://github.com/bo0ts/ddate"
  url "https://github.com/bo0ts/ddate/archive/v0.2.2.tar.gz"
  sha256 "d53c3f0af845045f39d6d633d295fd4efbe2a792fd0d04d25d44725d11c678ad"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2b9be177e37cb4650bae50a9527315e700592bdd8a5546cfb7b40cf201bb680c" => :catalina
    sha256 "bac9bcfe773de4c34915a353fe6f8808ac26f8253d0da9d43ab9787b4988ff44" => :mojave
    sha256 "31a72f135768fdf09ddc40539e3860e3489cf478cca07f6af71d8d3428447a78" => :high_sierra
    sha256 "61be1f5fc044574ede464807fba1e092bc165932a909a357f5cd71b0cbfd4726" => :sierra
    sha256 "fe87fe60ad1e8cbff1ebbcefd8be0f6f8ec87013a91e6385adbde0aebd45edea" => :el_capitan
    sha256 "ad575dd84b5d2ac8395c9cd11c4ef811f28f105eb81510369bb33078164ec2e9" => :yosemite
    sha256 "6d1dd4a9a1cc787cbd79add910fd80181dc5efc24712b9e84a7c37ce8de46d12" => :mavericks
  end

  def install
    system ENV.cc, "ddate.c", "-o", "ddate"
    bin.install "ddate"
    man1.install "ddate.1"
  end

  test do
    output = shell_output("#{bin}/ddate 20 6 2014").strip
    assert_equal "Sweetmorn, Confusion 25, 3180 YOLD", output
  end
end
