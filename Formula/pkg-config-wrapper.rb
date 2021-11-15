class PkgConfigWrapper < Formula
  desc "Easier way to include C code in your Go program"
  homepage "https://github.com/influxdata/pkg-config"
  url "https://github.com/influxdata/pkg-config/archive/v0.2.9.tar.gz"
  sha256 "25843e58a3e6994bdafffbc0ef0844978a3d1f999915d6770cb73505fcf87e44"
  license "MIT"
  head "https://github.com/influxdata/pkg-config.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "71bf9d7c8a50247e3a9de30fb64481e0db9e886d7181dd3c05a72ab7b10a7418"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7075a7f42b2b18f55ab420d46e2bf2601815ecb9a5a196c950616006d11acf45"
    sha256 cellar: :any_skip_relocation, monterey:       "cbe9f0cd7589661995bce4ffa59044fbfb68f7c5abc7063e5b2d658127089416"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba0929df16ae288d5511fc76c03211ae5e0dda1745bdc7662e15a8a219354132"
    sha256 cellar: :any_skip_relocation, catalina:       "086fb52e04ae52cc56049ebd830c99a7a967bb8def493f6a805d5d9dd4b0313a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3df85be9fce7fe749e27b381d85b774d3537f0700e64e58a2188087dbd221538"
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
