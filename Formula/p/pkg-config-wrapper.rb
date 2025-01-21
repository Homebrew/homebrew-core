class PkgConfigWrapper < Formula
  desc "Easier way to include C code in your Go program"
  homepage "https://github.com/influxdata/pkg-config"
  url "https://github.com/influxdata/pkg-config/archive/refs/tags/v0.2.14.tar.gz"
  sha256 "465d2fb3fc6dab9aca60e3ee3ca623ea346f3544d53082505645f81a7c4cd6d3"
  license "MIT"
  head "https://github.com/influxdata/pkg-config.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "918843c100312c7989536900ad3d290d425b9de54743685dd2f3b1511775ee69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "918843c100312c7989536900ad3d290d425b9de54743685dd2f3b1511775ee69"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "918843c100312c7989536900ad3d290d425b9de54743685dd2f3b1511775ee69"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5209cadce1517a6c12c81ece351367c2c37c75a4c9b9153e5c9ff1ff88bd455"
    sha256 cellar: :any_skip_relocation, ventura:       "b5209cadce1517a6c12c81ece351367c2c37c75a4c9b9153e5c9ff1ff88bd455"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a95298ce324c3fa5a0ea2ecafd015c31c84af68de6650112ef8cdf2bd11889c"
  end

  depends_on "go" => :build
  depends_on "pkgconf"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Found pkg-config executable", shell_output(bin/"pkg-config-wrapper 2>&1", 1)
  end
end
