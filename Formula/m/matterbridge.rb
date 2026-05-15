class Matterbridge < Formula
  desc "Protocol bridge for multiple chat platforms"
  homepage "https://github.com/42wim/matterbridge"
  url "https://github.com/42wim/matterbridge/archive/refs/tags/v1.26.0.tar.gz"
  sha256 "00e1bbfe3b32f2feccf9a7f13a6f12b1ce28a5eb04cc7b922b344e3493497425"
  license "Apache-2.0"
  head "https://github.com/42wim/matterbridge.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "5a41074e2c3eba976b8142b0f764732da7d5551396085b7b40ac5d62b5f1fd0d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6eec437022ff310f92909ef2f5e8b600f4e5cc2991fd7284fbed52d1d96a8ec0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5bb186836451a870eeec2e4954cce09eb426da52534f2e9d1acd105de1fa07ea"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "db4bd660db3e42897f23bffa81d3a241a2e41b56d035e649bf0ec6001dee5916"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a396b9c2aeb5a81600301142e52bca66298e8608e96f2355cec6dfcb07dbf31"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3622f41d47b3f71ff04a21b70d0df84e9fdf14f1e1fa65c85e91178be1d17a01"
    sha256 cellar: :any_skip_relocation, sonoma:         "0960b69b396c9439377a0f9e93bb0e69ff2af2be14deed3f50c38600e756f5d9"
    sha256 cellar: :any_skip_relocation, ventura:        "88c693006135c6475e9c3a0fea5aae515ffb0fc4f85bb1c77c256d997cba6f21"
    sha256 cellar: :any_skip_relocation, monterey:       "8ff7a6b8c44f153fca6cfc57e9219eebb211fb38df9ad764248fa0b4f12cf83b"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c2550e9e8a6ff8c2b9611ccfb46fcbfa5da753f6b79349f002a8c8823d5f960"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "e4aee8a1f75042ffafe421f8a228217ecf68b54c01499ea75db77495316b81e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4b90de5cbda5865e1150bdc823dd02bf4eaaa9358fc85de873e983b576ff5f34"
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
