class Lbdb < Formula
  desc "Little brother's database for the mutt mail reader"
  homepage "https://www.spinnaker.de/lbdb/"
  url "https://www.spinnaker.de/lbdb/download/lbdb-0.50.tar.gz"
  sha256 "afac83d8a4e33732007af70debf71a702db256213998e2efb313bb9bb17b81b0"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://www.spinnaker.de/lbdb/download/"
    regex(/href=.*?lbdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fab889c0974bb758db4ec78b98ac2d37a5427a873f9dca877d3391489dc17973"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "abd2d143d05cab01a3097793c12f3f7933cf926c9364ec33bd27b6bda19e5b63"
    sha256 cellar: :any_skip_relocation, monterey:       "42b0d2ae34f18b4eed75a48bda32c0ab7a887d4cf2532b5637f070d06d814d7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "d5bed5f3cb2fe1f3c12be02280cf1086a7a9e97189be908caa8ceea995c3c6fb"
    sha256 cellar: :any_skip_relocation, catalina:       "a4d4fa5b4e3147fc59e0ec1f6abd4d5c0d5da177b89815d7c79b569c51d414b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12b4bcf8f11f1ea4bf172423d30cb048c64702f10be58455bfc7a773ab91717d"
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
