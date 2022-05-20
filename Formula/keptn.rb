class Keptn < Formula
  desc "Is the CLI for keptn.sh a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/0.15.0.tar.gz"
  sha256 "a4b156d44a9b81efdcb75c527cd44e21745474e60ea2766b43f2744fb4bae264"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b8f6c505d4cadaea9afdeefad384453ee09a945077939f596dff42ef0d2ddb1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9fe1a058fb784936cb6cb8767eb3189d4a5ed8aa4ff7868bf3e94ec06e100b5e"
    sha256 cellar: :any_skip_relocation, monterey:       "232a834f43083eb27334c5e8510429116479082688a4a960a81d4e78bab8c0ce"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2312880cd64e048cd413402882872049e9eb149fc726a761e6c52a72580b129"
    sha256 cellar: :any_skip_relocation, catalina:       "317c8326c163dbb225fd214f79e25d333f8d91a135b04f1c380555e3bc821206"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a3dbe8266754a6b44bf27a5fe4129345d6b18de12283e53fededbd79a29c523"
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
