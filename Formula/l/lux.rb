class Lux < Formula
  desc "Fast and simple video downloader"
  homepage "https://github.com/iawia002/lux"
  url "https://github.com/iawia002/lux/archive/refs/tags/v0.23.0.tar.gz"
  sha256 "89554ef1eaa02705833ca76dfaed1c40a2ccae8d8e4aeb5221f6ffabb1592960"
  license "MIT"
  head "https://github.com/iawia002/lux.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "38be296f22a9ef07379522fcf83f6d19d59accbeffe0582e0171a01cf19f27a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "982abc1c6a41d07095cf8498b89aed157a2567bfb4554c650cbd4d5fa89689ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "383c71a75bf896630d1a61839120244ec06c9ee0259964c541a8d5e12614e62f"
    sha256 cellar: :any_skip_relocation, sonoma:         "d9ccf60a60b7cf5d9117709803463a17aab34cfc0d63c7478d82e9f428a89a40"
    sha256 cellar: :any_skip_relocation, ventura:        "f37e33edeef3cca4ca0e04dc351512e8d57173afee382fc8729223d68701c1a9"
    sha256 cellar: :any_skip_relocation, monterey:       "a9422d512142cede763869c86ccb3b01551c0b90158c36a72ef8fed1704de1a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed20549cdc7237423e2bf94e1b8677bd2c0e51d5852ce9a9969fe2e4e8aed7fe"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    system bin/"lux", "-i", "https://upload.wikimedia.org/wikipedia/commons/c/c2/GitHub_Invertocat_Logo.svg"
  end
end
