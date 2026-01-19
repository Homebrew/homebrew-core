class Orkes < Formula
  desc "CLI for Conductor - The leading open-source orchestration platform"
  homepage "https://github.com/conductor-oss/conductor-cli"
  url "https://github.com/conductor-oss/conductor-cli/archive/refs/tags/v0.0.44.tar.gz"
  sha256 "3da1e44ad382d604275e353c8f75114b4db25cc0c8f99921f73f24f91e48bd7d"
  license "Apache-2.0"
  head "https://github.com/conductor-oss/conductor-cli.git", branch: "main"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/orkes-io/conductor-cli/cmd.Version=#{version}
      -X github.com/orkes-io/conductor-cli/cmd.Commit=homebrew
      -X github.com/orkes-io/conductor-cli/cmd.Date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/orkes --version")
  end
end
