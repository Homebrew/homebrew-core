class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.25.6.tar.gz"
  sha256 "1a9297397a6dbcd00f194b47e509c4f404f06a8acdd41a07b4411556f46f681b"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b9b8d4911fce80aec153595d33f9a35ab1d995403e112e38fb69812fbb31dc9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "533ba521797b17388097713423a597acc75a3a7d0e06687c67dfbc44c526340c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "77900ca17bf2e42de261b45831880fb215b11ddcfb32850ffd5b076efac3cfab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b20e495029d82afe9a4d676f80533c261067722d14aa7332f483e32e5f26a51c"
    sha256 cellar: :any,                 x86_64_linux:  "ccdbdceb778b470c4e26ad1587e55f30aa67ab315f8e95ecbe85e57ea96ebac8"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "systemd" # for libudev
  end

  def install
    ldflags = "-X main.version=#{version}"
    system "go", "build", "-mod=readonly", *std_go_args(ldflags:), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
