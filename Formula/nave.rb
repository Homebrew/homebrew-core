class Nave < Formula
  desc "Virtual environments for Node.js"
  homepage "https://github.com/isaacs/nave"
  url "https://github.com/isaacs/nave/archive/v3.3.1.tar.gz"
  sha256 "c5789615135cf1b0b55c9e7422735bc8af4a2eee717cc09c0d520cfe88cc68a0"
  license "ISC"
  head "https://github.com/isaacs/nave.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba1b26cb794a07bace9800d71264fceb8b4b9efbddf6d9291399654d98bc88f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ba1b26cb794a07bace9800d71264fceb8b4b9efbddf6d9291399654d98bc88f9"
    sha256 cellar: :any_skip_relocation, monterey:       "1f245fcfdd7109a0939d1cb82a854407ac78bedb2bf140966b0d736c69e9a9a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f245fcfdd7109a0939d1cb82a854407ac78bedb2bf140966b0d736c69e9a9a4"
    sha256 cellar: :any_skip_relocation, catalina:       "1f245fcfdd7109a0939d1cb82a854407ac78bedb2bf140966b0d736c69e9a9a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba1b26cb794a07bace9800d71264fceb8b4b9efbddf6d9291399654d98bc88f9"
  end

  def install
    bin.install "nave.sh" => "nave"
  end

  test do
    assert_match "0.10.30", shell_output("#{bin}/nave ls-remote")
  end
end
