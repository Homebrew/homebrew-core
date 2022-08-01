class Keptn < Formula
  desc "Is the CLI for keptn.sh a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/0.18.0.tar.gz"
  sha256 "cd75cb9848bf22b5b61034807b0aa8e048dddad16bfa5b0ee090d2aebea3cce5"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5178fcb7961202c6be5264c40beca4086190f366f88ac2aaaf74feb9e22de2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d504b53b1bb6a7570ef42121b6337ffdea21c157a05f10b09ad0ed7bddba5704"
    sha256 cellar: :any_skip_relocation, monterey:       "f5cc2c1dad82ed4f83f8e8fb1b135ecb1c455241d3308408495956cd6fdb980c"
    sha256 cellar: :any_skip_relocation, big_sur:        "db3de974485a6d8a30bea7f883a60c024c013f4b545e924fdc0ef9e2bf870c96"
    sha256 cellar: :any_skip_relocation, catalina:       "903b15ec4a84e50fc52ac30931a09dcb4b3fc979c6e1b6bc404e8ffc614064f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c29c43102fcd8fa059fdc76bd9930033be4956b4c38cb5ea74fc438335469883"
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
