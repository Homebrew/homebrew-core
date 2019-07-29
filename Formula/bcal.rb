class Bcal < Formula
  desc "Storage conversion and expression calculator"
  homepage "https://github.com/jarun/bcal"
  url "https://github.com/jarun/bcal/archive/v2.1.tar.gz"
  sha256 "c0b6cb911a773abdd555e6a9e0eb8a25934ceca038156e6250e117fa451beaa6"

  bottle do
    cellar :any_skip_relocation
    sha256 "ceb385dfbcab9d34a2c54655729f934edf6ccc0eb135ba0cd580f9c384e64629" => :mojave
    sha256 "fc9abe164d34c568d66589d0cbeb1268044e763d6d6d93212badf10d5701aa04" => :high_sierra
    sha256 "5564379751e03bc62269e9edc689089713ca9a5d8113e0f33ea4ff8c83406427" => :sierra
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "9333353817", shell_output("#{bin}/bcal '56 gb / 6 + 4kib * 5 + 4 B'")
  end
end
