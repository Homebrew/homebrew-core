class Keptn < Formula
  desc "Is the CLI for keptn.sh a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/0.12.2.tar.gz"
  sha256 "78f7eabe5949ab7c675e92d7625431bc5d90b5e3e52cbd42a9708928a124fa2d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8377ddbde5f81f1db8cd32b5f9571757e6d668772b7d2e91c53348433d0eb2b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "40d61fc292f9133047db5c486acf6c2ba56b7377ae5cd5dc64b2bfa2ac9d420c"
    sha256 cellar: :any_skip_relocation, monterey:       "34abcf3112df2031a5fd7371ca1b68bfa455c8717939c338803ab94216216f7f"
    sha256 cellar: :any_skip_relocation, big_sur:        "753ab50bb5c12539d8119379e66249a06c09f7620718bcb9db0e28e07aebf58a"
    sha256 cellar: :any_skip_relocation, catalina:       "edcfcd08331d10b474248167fd10ff21d49d8d49062c219ac5d16e132e21dddd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7068d03a509135b0c3656b4bec94a44661d6590b980d8e53b71a6a46999372c"
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

    on_macos do
      assert_match "Error: credentials not found in native keychain",
        shell_output(bin/"keptn status 2>&1", 1)
    end

    on_linux do
      assert_match ".keptn/.keptn____keptn: no such file or directory",
        shell_output(bin/"keptn status 2>&1", 1)
    end
  end
end
