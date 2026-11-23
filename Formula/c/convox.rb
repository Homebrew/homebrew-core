class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.26.1.tar.gz"
  sha256 "429b9ba0b119273d374c4ce200b36a1e5889d927dbc847250bb412bc908fcabb"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/convox/convox.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "45ad227828a0cf5792e4ac2b8ef07d055cf14b4056792d1530d9bbc50923f677"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "cb14282bd266171bbbb5444e3a54c1091b022520dd1948bccd719dd8562b2a5a"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5fe5d017451ee1a2e36a85704d2cc2a4f4f917f52b066eca4aaf07246948bedc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2d4f91718d01a7d70ebcfee5343000adeb16d7bf14db530e34764dc53add3fa6"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ffeb89a1c3a4db9ce48960223e578df1dd8bb2c3c2e98da0cdfa7c987f9a44f5"
    sha256 cellar: :any,                 x86_64_linux:      "6dfede8650c6901514d0a7ac8777172b6afdfef431600e71344f8e1f7dc4c4f8"
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
