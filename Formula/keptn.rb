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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c763f5fe3e366367cc839de5a1bc99afd6a49ebcc89b09b66d44e458c1fc8e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f665e579effc7b94cb373a8d39cb83345ac0793786ba6b6771103689e666f80b"
    sha256 cellar: :any_skip_relocation, monterey:       "7aaf1840d90067e58d003e9330ff4c7bdecf1ea182eed62f39c67213aada8651"
    sha256 cellar: :any_skip_relocation, big_sur:        "b5a886506f3f07109dc0d3d97522edbb77073d901600def89285d5e28a7822f7"
    sha256 cellar: :any_skip_relocation, catalina:       "be07730ca4463601a0fea60cd3b81e8e4b737104f35c0901bf98f9ebd588d7de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52deaa26d0ae20c13c2ae9d96f398a0eeb6f7f1c731cec40fe6e2f8bcefe1f2d"
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
