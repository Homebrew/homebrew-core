class FlowCli < Formula
  desc "Command-line interface that provides utilities for building Flow applications"
  homepage "https://onflow.org"
  url "https://github.com/onflow/flow-cli/archive/v0.39.1.tar.gz"
  sha256 "75da9609ed4527a6ec22b0add666b74262cf2b7d697aebc162309be8f84911de"
  license "Apache-2.0"
  head "https://github.com/onflow/flow-cli.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b0d240efaef5f91f927df6ca9dbcd92ea9856f574ec2a0010b0fa31cd3add7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1f84bc01f284434b47a8dd7e228eedf7234b9da32f65d9cf8350da453eeb841d"
    sha256 cellar: :any_skip_relocation, monterey:       "ec9d3ced52068f56e3e703db313fa9bf18b2c40746ae6c45683a3717001699d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "a0b23ad2c14b9ff57871802c27b07eca4d4f78dd7505d183cd42828244ca92a3"
    sha256 cellar: :any_skip_relocation, catalina:       "9543e459032d04a4df2820612f0960e918a1bef4233629397643f59073f38c01"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1cc49f9ce01dec02cec9f792069a75333a8bd967e36451ff4be38ca1db10b6dd"
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
