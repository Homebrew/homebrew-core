class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/refs/tags/v0.68.15.tar.gz"
  sha256 "4540b5392a2ada9e37f73224ea884c1b7d74e5bf45b438bed3d584d8716f5236"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b72da1999d23ce17e8580c90b62f9a88f3818f7fdbd05c4f9526abba793b153"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7de8e96e6d46990fc7123c0c71bdaf36ef57b2e83447a6838931a1735cc28d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5d80fb9a1650fb8a75d92d5cd8d57eaf4f32102e0faeceed26fca158c3df3e6"
    sha256 cellar: :any_skip_relocation, ventura:        "6fafac649c447fd0f474ef5d613803be517bdad26e9e5b6bddf31443736b2ba1"
    sha256 cellar: :any_skip_relocation, monterey:       "b12bead1057582b97e28ce766a149cf02beeeb4e2624932dfe0c965b0916cd1b"
    sha256 cellar: :any_skip_relocation, big_sur:        "35dda684de1a913ddfb36fbeaa4e051f172fcbcafdddf2442f4a40f507d5ba44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d82abccd5e410b80c7712ce84ee6eb723b87d20d551a56eec5d1c6ac9f772f22"
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    bin.install "bin/#{OS.kernel_name.downcase}/newrelic"

    generate_completions_from_executable(bin/"newrelic", "completion", "--shell", base_name: "newrelic")
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
