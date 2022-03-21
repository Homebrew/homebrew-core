class Nave < Formula
  desc "Virtual environments for Node.js"
  homepage "https://github.com/isaacs/nave"
  url "https://github.com/isaacs/nave/archive/v3.3.1.tar.gz"
  sha256 "c5789615135cf1b0b55c9e7422735bc8af4a2eee717cc09c0d520cfe88cc68a0"
  license "ISC"
  head "https://github.com/isaacs/nave.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18d0ec2aa28f1556b535d1e1c818fdcc63f29278749ec9a384cf510dcd4e3b97"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18d0ec2aa28f1556b535d1e1c818fdcc63f29278749ec9a384cf510dcd4e3b97"
    sha256 cellar: :any_skip_relocation, monterey:       "45ee6cd3fbe703c724da73a37c8fea7bfde5bb59f87c71dea630a5c3a0d1df9f"
    sha256 cellar: :any_skip_relocation, big_sur:        "45ee6cd3fbe703c724da73a37c8fea7bfde5bb59f87c71dea630a5c3a0d1df9f"
    sha256 cellar: :any_skip_relocation, catalina:       "45ee6cd3fbe703c724da73a37c8fea7bfde5bb59f87c71dea630a5c3a0d1df9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18d0ec2aa28f1556b535d1e1c818fdcc63f29278749ec9a384cf510dcd4e3b97"
  end

  def install
    bin.install "nave.sh" => "nave"
  end

  test do
    assert_match "0.10.30", shell_output("#{bin}/nave ls-remote")
  end
end
