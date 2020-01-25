class Bcal < Formula
  desc "Storage conversion and expression calculator"
  homepage "https://github.com/jarun/bcal"
  url "https://github.com/jarun/bcal/archive/v2.2.tar.gz"
  sha256 "506d17d6df35fad636d3ced425afee5921cd2b21242099b78b369cfcb5716e23"

  bottle do
    cellar :any_skip_relocation
    sha256 "037f7b75eb8d0485c2dc770d6f592549287559e5b4afeb4458bc16bfa3424795" => :catalina
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
