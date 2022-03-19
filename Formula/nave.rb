class Nave < Formula
  desc "Virtual environments for Node.js"
  homepage "https://github.com/isaacs/nave"
  url "https://github.com/isaacs/nave/archive/v3.3.0.tar.gz"
  sha256 "4af41bc3863c37bb72f2861ca44fe1f4cd74711cba2bf3ca24e7d102ac8f8298"
  license "ISC"
  head "https://github.com/isaacs/nave.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15cf715e852ecfa6b1e27db2e85882a2ce4c186d4c884ef499ab3235f0fd031f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15cf715e852ecfa6b1e27db2e85882a2ce4c186d4c884ef499ab3235f0fd031f"
    sha256 cellar: :any_skip_relocation, monterey:       "415b8d8291219249edfa41148152288c201a08fea28ab0a44413ea656efdf1e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "415b8d8291219249edfa41148152288c201a08fea28ab0a44413ea656efdf1e2"
    sha256 cellar: :any_skip_relocation, catalina:       "415b8d8291219249edfa41148152288c201a08fea28ab0a44413ea656efdf1e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15cf715e852ecfa6b1e27db2e85882a2ce4c186d4c884ef499ab3235f0fd031f"
  end

  def install
    bin.install "nave.sh" => "nave"
  end

  test do
    assert_match "0.10.30", shell_output("#{bin}/nave ls-remote")
  end
end
