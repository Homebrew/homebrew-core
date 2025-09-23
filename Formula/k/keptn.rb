class Keptn < Formula
  desc "CLI for keptn.sh, a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/refs/tags/1.4.5.tar.gz"
  sha256 "2b767fedf0ac9581b914bb6c89720749023cf102d154c283697a653103a3318c"
  license "Apache-2.0"
  head "https://github.com/keptn/keptn.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "6890b7bf9d1147ffb7b3399b83f07fe7302594687bdc560e61ff94bcbcd01483"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "423b33841420a90882c5969217d114ab5deab10ef1c06c79b32b4629daff77ca"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1b1139e9d32bcf7c1cc2f576952aae560568efcb57267267d682944945f0345"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "736007fe68b58bc08c475c4cfe1297c609216eb289d507b746652a3737511abb"
    sha256 cellar: :any_skip_relocation, sonoma:         "6c44a452fe99b5dd940d2cc5ca32d9d38aed9486de7b49e730646ada4b74e4c3"
    sha256 cellar: :any_skip_relocation, ventura:        "df51b37cc88aeef3a096468048c533c9bec399e0e51630ef0d4b99b00e1f98ca"
    sha256 cellar: :any_skip_relocation, monterey:       "b70fb2caa668ef82dcb5a46340bb831d055f6922e200edd74f8d6dbc19910b73"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fc0beacc9f716d912ecc6cb638b023c98a87cb079ea782e787f6de36b50b2c1"
  end

  disable! date: "2024-12-21", because: :repo_archived

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/keptn/keptn/cli/cmd.Version=#{version}
      -X main.KubeServerVersionConstraints=""
    ]

    cd buildpath/"cli" do
      system "go", "build", *std_go_args(ldflags:)
    end
  end

  test do
    system bin/"keptn", "set", "config", "AutomaticVersionCheck", "false"
    system bin/"keptn", "set", "config", "kubeContextCheck", "false"

    assert_match "Keptn CLI version: #{version}", shell_output("#{bin}/keptn version 2>&1")

    output = shell_output("#{bin}/keptn status 2>&1", 1)
    if OS.mac?
      assert_match "Error: credentials not found in native keychain", output
    else
      assert_match ".keptn/.keptn____keptn: no such file or directory", output
    end
  end
end
