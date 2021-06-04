class Macchina < Formula
  desc "System information fetcher, with an emphasis on performance and minimalism"
  homepage "https://github.com/Macchina-CLI/macchina"
  url "https://github.com/Macchina-CLI/macchina/archive/v0.8.21.tar.gz"
  sha256 "0aff873ae30715f79c6e37f593e48d9505594d4a171e77e04377f9beec54c106"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2cbfe68f8747f0735b2e2705ba360cdf9d9c5fa2618bfa0df2e07936c23ea049"
    sha256 cellar: :any_skip_relocation, big_sur:       "99c2a91884f0a91ad6f5d10a4f2211dd43f9e75726e9027517c6c8a74ac865a6"
    sha256 cellar: :any_skip_relocation, catalina:      "f3fa46401a0a2af959f09c1994f184347bacf39f61b726be70d09f956564cac9"
    sha256 cellar: :any_skip_relocation, mojave:        "35d7b3d9cc79d9e7ae2958e8e65d1bc60f1482789178715a55cf3558e6dad0dc"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "Let's check your system for errors...", shell_output("#{bin}/macchina --doctor")
  end
end
