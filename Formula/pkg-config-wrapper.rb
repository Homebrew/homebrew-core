class PkgConfigWrapper < Formula
  desc "Easier way to include C code in your Go program"
  homepage "https://github.com/influxdata/pkg-config"
  url "https://github.com/influxdata/pkg-config/archive/v0.2.12.tar.gz"
  sha256 "23b2ed6a2f04d42906f5a8c28c8d681d03d47a1c32435b5df008adac5b935f1a"
  license "MIT"
  head "https://github.com/influxdata/pkg-config.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66065a484014b423fff9309c6e3175d20d2cc23566f5e4058aa938e45fa4ef2c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4930c1285c030215028f82a746846895d3871599690af24b7f31469341d317a"
    sha256 cellar: :any_skip_relocation, monterey:       "044772ffafe9780982a17903be7bf3c61bca1c5505b31d073f37d773e5e74c02"
    sha256 cellar: :any_skip_relocation, big_sur:        "7fcee27d263abc47ad91c95d25f90c4c5fa84e8c4a1df3ac62f33e7dd7a745e5"
    sha256 cellar: :any_skip_relocation, catalina:       "2e4d0f49885a6f4761d07ecbcc6c2fe3d380001b8c3556e918fa516958971a37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4eaab9d90c749c90c049befc6a1a971540cba9e925d5fa0df4f366a44df7a274"
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
