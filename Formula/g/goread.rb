class Goread < Formula
  desc "RSS/Atom feeds in the terminal"
  homepage "https://github.com/TypicalAM/goread"
  url "https://github.com/TypicalAM/goread/archive/refs/tags/v1.6.3.tar.gz"
  sha256 "14d5a828a0ecb86625c3994baf44258e3b3ad40c77df1f03b120ed52b3dca261"
  license "GPL-3.0-or-later"
  head "https://github.com/TypicalAM/goread.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "15475a54e9e92a69d53135e4628bc0d1804ee45bb37003d5ca7f8db6ee6090a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "71dade7c91d29fa14946ce03ad085f635a7299b25e91aacc1e2dccf5129f3b56"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0adc0fa41e7136481dac275b853b293f434f7183f4b006bf0cf1c87ca77d5b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "97a619119c9de268ec5f53a1e89265689cce0125a571aab6b826d9be2b65346e"
    sha256 cellar: :any_skip_relocation, sonoma:         "0ba48c9fe8a1e328837ab6687183b2ca5bb6a97fb2a14728eda3f624e4159c0a"
    sha256 cellar: :any_skip_relocation, ventura:        "67582753d0240c183892725f2198498eda530461b256a177ba7d10934fe02eb3"
    sha256 cellar: :any_skip_relocation, monterey:       "d1d5f427f5c04e8f4563021b7b47cf1e58c4fd873ca20ed6f5f63c7d41fb24d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e5594ef5ad277959e0ef3ee2afd6300e9453ed2c21581e3f8b81a16d0c12c1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "177180b8cb0c4b9da3e61958117130835ab83bce33b1d0d3b670ee0d5bbb7fe3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    output = shell_output("#{bin}/goread --test_colors")
    assert_match "A table of all the colors", output

    assert_match version.to_s, shell_output("#{bin}/goread --version")
  end
end
