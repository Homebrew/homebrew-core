class Matterbridge < Formula
  desc "Protocol bridge for multiple chat platforms"
  homepage "https://github.com/42wim/matterbridge"
  url "https://github.com/42wim/matterbridge/archive/v1.24.1.tar.gz"
  sha256 "ee2177f458a29dd8b4547cd6268fb8ac7e2ce2b551475427eca1205d67c236f4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09af9fe5a2ae884e35003194074d3f079f64d1c068bbba89eefe2c320461008d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad14117ab2d60b12a2024ae49cea48a6b825d53d24a8024010e46c24fe267a6b"
    sha256 cellar: :any_skip_relocation, monterey:       "61732cc7ab2e4bd98a2cd9d3e9ae38b542a6084d1e6b4491c87e7304c696b5c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "7b49e10b03008adc39e30f062bf1cad91901cc5be8667b1bef75582cae98e092"
    sha256 cellar: :any_skip_relocation, catalina:       "99e8d3f6f02cd8b2bee16d431d87e77220ffb589826ec13ee91a0b95cba638e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "166cee591d0a46fba697b7d33736b05c107289cc37fd416f6f49011fa87b6de8"
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
