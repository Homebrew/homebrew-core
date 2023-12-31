class Genact < Formula
  desc "Nonsense activity generator"
  homepage "https://github.com/svenstaro/genact"
  url "https://github.com/svenstaro/genact/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "79e1c4173757ddbf3b6878ae83d09905ea7c38d5366aa08a50e96e566cd12478"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8f726355cba8d4d9ba424368c9f4cd127a77890e6a930b74717c342880bd97f1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "83e8e50f416a8060b3500282e7c1b339db43ef29ba17b184e1f1b40f4a223543"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "335695ef66c99f851bd1b76d3680d7bd8534ef1882e64e874e682c504b406ce6"
    sha256 cellar: :any_skip_relocation, sonoma:         "7603da9c56ce94a109f418980e18ea171257d6c08f8b0664c4ae9d6848bc7966"
    sha256 cellar: :any_skip_relocation, ventura:        "b408a34bf1091c707e911815bca3eb7d12abe7f17a7bb5c8bcdffba2491e59b0"
    sha256 cellar: :any_skip_relocation, monterey:       "2da719b66d8ade9699f49f3e6ce996b61848a9081faf03d36d799ad6a3a50a5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93dc180f30bbe70bf91c5e6cf75710a06d7d2eaef0288ad71cfbe1668808e0b9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Available modules:", shell_output("#{bin}/genact --list-modules")
  end
end
