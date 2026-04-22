class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.24.4.tar.gz"
  sha256 "1da2190232031902b950c74655927db1762978ea8cd4a1714da3837b17700d80"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "352a4b6a27d55d4218b48865aea5386f6fee5422ec23fc2c43079966ec4f5015"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79fcebd1ff061235f4e3c1eea00b2e3e03ee2469acb5c05aa5695681470ebb21"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "753c03c148f142782afc6d18392d3759a439679397f5c7784f748255d2460e5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3936207fc43be986860ea22467b7291d3d16f37c87e598974d8baddd3883b8f4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a1e131f7af67154de324d99b9b911799b63cf8c7a7c70a10b67d1f35d72436f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "796c51a5ff74d8c6212233f0d3b08bf28861b7b799522cabe95a3c35f2ca9c20"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "systemd" # for libudev
  end

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", "-mod=readonly", *std_go_args(ldflags:), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
