class PkgConfigWrapper < Formula
  desc "Easier way to include C code in your Go program"
  homepage "https://github.com/influxdata/pkg-config"
  url "https://github.com/influxdata/pkg-config/archive/v0.2.8.tar.gz"
  sha256 "9d3f3bbcac7c787f6e8846e70172d06bd4d7394b4bcd0b8572fe2f1d03edc11b"
  license "MIT"
  head "https://github.com/influxdata/pkg-config.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "132d305934de84c9d98d82912312f0cbb7204dbf203277730fd1ef2238ee5621"
    sha256 cellar: :any_skip_relocation, big_sur:       "0c13ac5e30bafee95d4190ba733305bf481195299cc07d665bf25c7b34183f63"
    sha256 cellar: :any_skip_relocation, catalina:      "164299afc7de07a790856a3a6c3aa05a129584e1d60b9d40d0d429775f5b2fff"
    sha256 cellar: :any_skip_relocation, mojave:        "c6d86cb0821de7c39da2ee6f6b4ee30638f61d63a0a851bbd0b6ccc6ea811710"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6c737a65676cc36f64a90c9ee8e2d8c3f9c1dc9d7c1d57a8f844473d7e0f64df"
  end

  depends_on "go" => :build
  depends_on "pkg-config"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Found pkg-config executable", shell_output(bin/"pkg-config-wrapper 2>&1", 1)
  end
end
