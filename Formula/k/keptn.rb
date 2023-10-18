class Keptn < Formula
  desc "CLI for keptn.sh, a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/refs/tags/1.4.3.tar.gz"
  sha256 "4889bfc2dc868809d5dcb2b18d52cb5f7583a3eae31fc56854a62fbccb271078"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "933c620f28c6178e0b26d994f0f8fd648a6d913b29f177aacae210b57abd0cb2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f968e6b871efd635106229de1785bf19788b0595170ad34562a43fdece9f8d07"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6761113d92201c2be299c99e34fce5c2c98b1501f29b8a2cf6791c111b6e754e"
    sha256 cellar: :any_skip_relocation, sonoma:         "8ece1980edd356a32dabb7e8072849333c05527d795e3fdfb506ddc161adcc57"
    sha256 cellar: :any_skip_relocation, ventura:        "56d4d4e46c87c8568261be31941717375b80883659f881418737a1e3e7d62fa2"
    sha256 cellar: :any_skip_relocation, monterey:       "1c7ec8da7707f6a7e515c44d85b4090736f445aa34610b12e5c136946b46c564"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "576f00490d5191d0e5e367fa929fa2447ddb5dd5643d0d67fd8c7030589ce1f6"
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
