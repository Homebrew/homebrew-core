class Matterbridge < Formula
  desc "Protocol bridge for multiple chat platforms"
  homepage "https://github.com/42wim/matterbridge"
  url "https://github.com/42wim/matterbridge/archive/v1.22.2.tar.gz"
  sha256 "13161735dd51ced98ad9525a188c4eab739c92d2f82889fe3e9577b2bf9b75dc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0f7d48db4c678ee01d7641ca23783123afd2abe4cada84dd0fe42b6fbfc0cecd"
    sha256 cellar: :any_skip_relocation, big_sur:       "9f401ee30df6117685ecff3f77218aad5d6967292eec2e3654d53dba7940d5d1"
    sha256 cellar: :any_skip_relocation, catalina:      "c645a03c31460a503da13fe3273a8591e60f912a8e88d8e4f4bd6bf788598602"
    sha256 cellar: :any_skip_relocation, mojave:        "c5cf1f479e6fa88acebd2367160fba769cef7d6d7a5779340496948fb5ae04e6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    touch testpath/"test.toml"
    assert_match "no [[gateway]] configured", shell_output("#{bin}/matterbridge -conf test.toml 2>&1", 1)
  end
end
