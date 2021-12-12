class Gotify < Formula
  desc "Command-line interface for pushing messages to gotify/server"
  homepage "https://github.com/gotify/cli"
  url "https://github.com/gotify/cli/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "9013f4afdcc717932e71ab217e09daf4c48e153b23454f5e732ad0f74a8c8979"
  license "MIT"
  head "https://github.com/gotify/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7b63037731fd33f8a8eaee905dcfa10e337a67b3a4863b7fc1f7a6e5a5565ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9cd577a557fc7377191c9ca72a97522a6e1419f840cbbf7258640b25a80512ad"
    sha256 cellar: :any_skip_relocation, monterey:       "ed62bf203d24de174a32d5c74a1f60f84bd19bbf64256e831cf696f951b6a68f"
    sha256 cellar: :any_skip_relocation, big_sur:        "7dd11a2030ff16042ba0f8ce680ae550ee20568444b94ebed12cd95c7dba75a9"
    sha256 cellar: :any_skip_relocation, catalina:       "29fe9342e485691f43130afb0665776245a7b6d12d2c907ebbe1c30181d6a731"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa631cdc0e667a7d9ead93739fecca5e04ad1a1b042bd46ee6450f3c231bb565"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}
                                       -X main.BuildDate=#{time.iso8601}
                                       -X main.Commit=N/A")
  end

  test do
    assert_match "token is not configured, run 'gotify init'",
      shell_output("#{bin}/gotify p test", 1)
  end
end
