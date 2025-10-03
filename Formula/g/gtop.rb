class Gtop < Formula
  desc "System monitoring dashboard for terminal"
  homepage "https://github.com/aksakalli/gtop"
  url "https://registry.npmjs.org/gtop/-/gtop-1.1.5.tgz"
  sha256 "a8e90b828e33160c6a0ac4fb11231f292496e8049c0dac814e46fdd0c90817c1"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "aeecdb4bbb42c07c1a990d31f2cc69bc6dd861897ce5e6f29cc69b6c4a5ea3ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "19886395a17a873daab79bd8e8970e7a9606d4389586123e68d875c2fd192c0f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a4641e216717d7a5a9b15b74823300c209d4b524bfb67044eef2feb1269a014"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a4641e216717d7a5a9b15b74823300c209d4b524bfb67044eef2feb1269a014"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a4641e216717d7a5a9b15b74823300c209d4b524bfb67044eef2feb1269a014"
    sha256 cellar: :any_skip_relocation, sonoma:         "c553e5fc33023ca5721afcfa8a427ee24728fe83c4b3b959f7c2f297d9d7765b"
    sha256 cellar: :any_skip_relocation, ventura:        "c553e5fc33023ca5721afcfa8a427ee24728fe83c4b3b959f7c2f297d9d7765b"
    sha256 cellar: :any_skip_relocation, monterey:       "c553e5fc33023ca5721afcfa8a427ee24728fe83c4b3b959f7c2f297d9d7765b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "dbd2e93ffe00474fa327abc717c860e3d4254e09449c83cc01b1e860f3d6ea2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51f39616a98ddb6a0f1bf391b3c2155e1b0ba0c192ddb8c735dfb6ae5a24fed7"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    assert_match "Error: Width must be multiple of 2", shell_output("#{bin}/gtop 2>&1", 1)
  end
end
