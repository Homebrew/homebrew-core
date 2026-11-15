class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.26.0.tar.gz"
  sha256 "a67d184e33da16881d2afd624a680ca8bc14b63f0df203de67a5f26e571ffd07"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "6b6d0b84f78d863506af4d0bd922c80a72ef5c6311ee4e4645f84ae63627216c"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5a952f1a691565916834f0864cefc34337d9a299cba131118885a4108cc869a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "e0602b0d86d7499c12f492c9e95a0510baa37009e4895e71e4ec78a027df2dfc"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "397532a87120c59e5eb5e8d443950953f13112381aeba58b713929c3ccff1740"
    sha256 cellar: :any,                 x86_64_linux:      "70c388dd65bd680fcdd0ac1406eb1f683639dc4ecd375673fad0707e15fdda71"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  on_linux do
    depends_on "systemd" # for libudev
  end

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
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
