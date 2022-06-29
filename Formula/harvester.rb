class Harvester < Formula
  desc "CLI tool to manage VMs on Harvester"
  homepage "https://github.com/belgaied2/harvester-cli"
  url "https://github.com/belgaied2/harvester-cli.git",
      tag:      "v0.1.0",
      revision: "c2962916b7e379b609c5092247ec28f0c8875a09"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    Utils.safe_popen_read("git", "rev-parse", "--short", "HEAD").chomp

    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=0.1.0")
  end

  test do
    output = shell_output("#{bin}/harvester --version 2>&1").split("\n").pop
    assert_match "harvester version 0.1.0", output
  end
end
