class Keptn < Formula
  desc "Is the CLI for keptn.sh a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/0.16.0.tar.gz"
  sha256 "09bd95e3eac537d8a040fea1c0b8fc7a0497b8c98b6e402d31ae207a24df0fea"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c3e1b9a6f0793d493e324c33739c88618f4953f724b979e96529ab899010a0a2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "820113ca518485f2f95b892c15f6ef4431812a923b21c37198d28f89f685485b"
    sha256 cellar: :any_skip_relocation, monterey:       "6486273684b2c695c0d92266953a6a1ea130263c51286faf7a4fae61d64e0d89"
    sha256 cellar: :any_skip_relocation, big_sur:        "071bad2fb1809c004570d4b7060cc42d7a63f3189ee31bed54a49026f2b0dc86"
    sha256 cellar: :any_skip_relocation, catalina:       "a3b2fd55ae40d0a0287e8546be6aa1befabb0fe159d250e996457626d517e9eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3aa852c5ed949ed5b2609424464c2f902e863d535190179205e6dd0881e38c8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/keptn/keptn/cli/cmd.Version=#{version}
      -X main.KubeServerVersionConstraints=""
    ]

    cd buildpath/"cli" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end
  end

  test do
    system bin/"keptn", "set", "config", "AutomaticVersionCheck", "false"
    system bin/"keptn", "set", "config", "kubeContextCheck", "false"

    assert_match "Keptn CLI version: #{version}", shell_output(bin/"keptn version 2>&1")

    output = shell_output(bin/"keptn status 2>&1", 1)
    if OS.mac?
      assert_match "Error: credentials not found in native keychain", output
    else
      assert_match ".keptn/.keptn____keptn: no such file or directory", output
    end
  end
end
