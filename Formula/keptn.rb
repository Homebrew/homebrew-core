class Keptn < Formula
  desc "CLI for keptn.sh, a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/1.3.0.tar.gz"
  sha256 "54ad9d102992809f4a18fef8d63ae408ba0743de3b1b3c072f770e1a42ae95e6"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "309eb9a76f828e3ddeae7943fef327afd4bac43fe8cba54f9fa32858a5b5b260"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc5b378334ac7f04f7b8025e13a8d9c3c36f60a25458940dfde5b3353b849fb5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b11724d71653f3af63961e639be5dad904597cf1051ede8e3ea92433e822c8c1"
    sha256 cellar: :any_skip_relocation, ventura:        "b8d368962482a1f52499113fc44234d514378aa1a90a9688099d5c1b91a257cf"
    sha256 cellar: :any_skip_relocation, monterey:       "6b6bf3a93396e81726fc2afb8371dc0bc0e5a133f88eb0a24c1414ed640f21c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "4bfc02382e17b8ac9df69221dd7801a9bd282ffaa38653ed7ad635cd99622f1c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "814fed8cfd763afb7a11217ba37c2eabd68bc2d2f502d86753062c4a1a74f5a9"
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
