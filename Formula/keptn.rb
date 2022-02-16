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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e52ec0e56e5c4cc870833754673cfed25112713a6a15ad3ad94e2fffeac6c02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1bf985a483f191d8b882523c1ef89a6e597da25ecc59036299f26d0609d7780d"
    sha256 cellar: :any_skip_relocation, monterey:       "8139b66733d51310f95071dea2e89c969f4026490c3f7c649c378caa77431197"
    sha256 cellar: :any_skip_relocation, big_sur:        "82c51024ba5b2f2e6736574e67098f588dd21c862bd2d3578ed8b5858748d7e1"
    sha256 cellar: :any_skip_relocation, catalina:       "c9bfedf826a6ed47ec76533045dfda17e110235864334fe5ee01d8ed7ba6c68b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d8635ba855ac43b730201726ba8c58b256dd91b12a67baf6f73afa1e67e42c8"
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
