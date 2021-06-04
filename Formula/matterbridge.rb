class Matterbridge < Formula
  desc "Protocol bridge for multiple chat platforms"
  homepage "https://github.com/42wim/matterbridge"
  url "https://github.com/42wim/matterbridge/archive/v1.22.2.tar.gz"
  sha256 "13161735dd51ced98ad9525a188c4eab739c92d2f82889fe3e9577b2bf9b75dc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8db9ccd73a5d02ef58a1ee6fa7d57170bb12f5e2c8023889e73c58e2d07582f5"
    sha256 cellar: :any_skip_relocation, big_sur:       "06f7efe69aa0856a433b8dbeaa7f938b9095ed5bbe52dd754ffd1911e3c5c6af"
    sha256 cellar: :any_skip_relocation, catalina:      "729c8c25957af43a7d69e51ff1f80dc68bc082f69f46ecc55ae2767bdcd96987"
    sha256 cellar: :any_skip_relocation, mojave:        "d1975a2a13ef3b2234833b4f031829d9ca536ce0fd5cf19632203ab33e01def0"
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
