class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.36.0.tar.gz"
  sha256 "b3bb705524e2d886e2cdb90b67c2774179deebfd8cc4ab6ee0996eae8ef6d904"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df4a1c1d4a246245dea6872eb9fe3088fd0b6e611f0db396c405a6179b59e9b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74535e189ece4bbaf0070da6ada5ab12ac836efff85948a90edaab12ab9b74ad"
    sha256 cellar: :any_skip_relocation, monterey:       "551a9da407b3411072e84ac549e23b202459324d8e10e852ee6bed66cafad957"
    sha256 cellar: :any_skip_relocation, big_sur:        "739bf1ff8cd290a7f5a8b87d1b7520bc9847a84155d9a03f718c735149b886c2"
    sha256 cellar: :any_skip_relocation, catalina:       "600b2bf12118086063e803615a8063bb2139e96a0ec099408c311eae6c9a2097"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1212a8ab44e96a8129c27ddd702cb411bbf6be1741b3b18416649e98f88e85ba"
  end

  depends_on "go" => :build

  def install
    system "make", "cmd/flow/flow", "VERSION=v#{version}"
    bin.install "cmd/flow/flow"
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main() {
        log("Hello, world!")
      }
    EOS
    system "#{bin}/flow", "cadence", "hello.cdc"
  end
end
