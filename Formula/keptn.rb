class Keptn < Formula
  desc "Is the CLI for keptn.sh a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/0.13.4.tar.gz"
  sha256 "c60aa30a91e5e10cff44d4416b651ceaa1ad4a4587551363b1ab69b896896f7d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95db869b25ba2ae09d716c22cb7cceeace0cea3460259f586c1bb05994467b13"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "50a29898b97a8c279cda4d4f58321ec83e0524581d47372c1a5a905044e679f9"
    sha256 cellar: :any_skip_relocation, monterey:       "8f1ecaaae19ca76ce17b7ceae0908dfe393487326a4d6fe5b8eeae27bdc4e85b"
    sha256 cellar: :any_skip_relocation, big_sur:        "80adee13d680675eb451d421f0dd054b25729929b0b9d106775c94a1f5180f05"
    sha256 cellar: :any_skip_relocation, catalina:       "44ace5c7cb126fd7d0ae8ea66873b552131b0f929b625680a4113121ff8f65b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7db8fb74410e6def5fdacb64bf1b3c6814d50a711fd6166045c6c1fe99d9bf63"
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
