class Keptn < Formula
  desc "Is the CLI for keptn.sh a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/0.19.0.tar.gz"
  sha256 "511e53a047f4e40bd2935564ed638ce0a23a83a1fd0bab4e10f7579bc3c22ee1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cea3b99f8e05de12dc9e58d4266cf95a37452196ec4516be34f0a70ea331c5de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "582de26565b5f3c163d5062bec15307186a0ef7fcb9f3b62fcdac42539e85c22"
    sha256 cellar: :any_skip_relocation, monterey:       "658e26ded68751e0898823a0d832610279133e09b3eb64158270f53c24dcf81e"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb3a9b5c825193bc2074601e81fc5a961b7bb3de033b30d7e5b70284aeb2da94"
    sha256 cellar: :any_skip_relocation, catalina:       "63a20c3d3da0b3fe3ef00944dcba347509f2977e68bb76fdc7482edd17c14488"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e914f5f1c5de71e483cae71936ace3d7842c709e8d30d4d90e2f19840aff844"
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
