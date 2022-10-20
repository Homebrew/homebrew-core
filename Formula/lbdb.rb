class Lbdb < Formula
  desc "Little brother's database for the mutt mail reader"
  homepage "https://www.spinnaker.de/lbdb/"
  url "https://www.spinnaker.de/lbdb/download/lbdb-0.51.1.tar.gz"
  sha256 "97e69fa6535e59869fc42431abe70f5cca4164890d0df2736081a94e1b3625ef"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.spinnaker.de/lbdb/download/"
    regex(/href=.*?lbdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "27aaf73b84538a78fd40cfe19f8d5adff6a3277a639085a5b9510d5546caeff1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e308f798530d35ee7a77fde6a35da9ffa02a039dc2a8c18e3257c24b708b6a14"
    sha256 cellar: :any_skip_relocation, monterey:       "7cd1dd2a1209d574ae112e116121414bd0bdda73094699f9bd5a87b87ca13485"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e95deee2c312e77e6519aef3a9e78702b1e4aa693f86c390a76a078beef4de5"
    sha256 cellar: :any_skip_relocation, catalina:       "61ebb0db54a8f0a14704c5d409917eece096fca4d936f45aa5908ce7aeec6ace"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72d1f94b284ddd49b2c172152ea4212b821788a57dd46a43832e301379015414"
  end

  depends_on "abook"

  def install
    system "./configure", "--prefix=#{prefix}", "--libdir=#{lib}/lbdb"
    system "make", "install"
  end

  test do
    assert_match version.major_minor.to_s, shell_output("#{bin}/lbdbq -v")
  end
end
