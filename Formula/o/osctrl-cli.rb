class OsctrlCli < Formula
  desc "Fast and efficient osquery management"
  homepage "https://osctrl.net"
  url "https://github.com/jmpsec/osctrl/archive/refs/tags/v0.5.4.tar.gz"
  sha256 "1047424879652f42bd8b444859db0a965e55caa5fbae223be1ebefe9b2eb653a"
  license "MIT"
  head "https://github.com/jmpsec/osctrl.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a7bcbbd4226ca25564926209b0ed1648dceef5475ae9bd2171c5dd71c540bb1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "27ae069566e9626e7237836564aebdff28d70b8947593883de4d039882e7d7b5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ccec2c45f80eaac1094c08d781a0cb7602a5fd306a4be443fdcaf4baec561e3"
    sha256 cellar: :any_skip_relocation, sonoma:        "d523dd5b9bba9e401a9172babaf1e99dd46b4a10a81b39d398c01f7485c52221"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a713be38b8d8db9621c28002bcf5293ac852591dac1c505763753cb97572a91"
    sha256 cellar: :any,                 x86_64_linux:  "71897c4093ee2a93e9ba71630b505df8d454bfbe928e7cdc6c8de77d97bee8f4"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cli"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/osctrl-cli --version")

    output = shell_output("#{bin}/osctrl-cli check-db 2>&1", 1)
    assert_match "failed to create backend", output
  end
end
