class Keptn < Formula
  desc "CLI for keptn.sh, a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/0.19.3.tar.gz"
  sha256 "abe29dc9eac9492be9d3836f54335081c84a572ca5ea77d14cca5d062080c963"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0efa2e9610e487fb54bfdd82a879e56e5f4f8084569022469cf8a4a98e57b0d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01f737d9519e4c9f9e36619dc18fffe79819aac816f3fedb68c3ebc2f2ef9dbf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ce4d7e6927d4ef0a4f6b7909195ced9dd5a5866f698fdccb0cb7841f742a0c4"
    sha256 cellar: :any_skip_relocation, monterey:       "1cd1481e64d1cada9727831969d1f832197f5bde35a04245b8f7f3c3e7946534"
    sha256 cellar: :any_skip_relocation, big_sur:        "59c30ced5ff672bf84c46bb3ce31f7c0d11713e5a521fee79e0e32944723d630"
    sha256 cellar: :any_skip_relocation, catalina:       "1480eba69a3fc26ab34acb39cbe369cfec5ce9e447228a0db35fcd187f5b4230"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ae94cb7b5289c8def6c0e09e9dfc5d30c3753e3b3fc1aa5dbea6391a768a9dc"
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
