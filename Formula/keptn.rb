class Keptn < Formula
  desc "Is the CLI for keptn.sh a message-driven control-plane for application delivery"
  homepage "https://keptn.sh"
  url "https://github.com/keptn/keptn/archive/0.9.0.tar.gz"
  sha256 "297bedbe1999815391c68b86d8826aa3ef8d151986d5d2758dae4cfd21a8fed0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "eb881a918fcfcd2bb7c08f7279bf32f45b5451facacacddbe15a6815c78476dc"
    sha256 cellar: :any_skip_relocation, big_sur:       "fddf741b6a464608285a10972531652bdc5dc86e9e0aefb750aa373445da05c2"
    sha256 cellar: :any_skip_relocation, catalina:      "9c50b1d8a015599aceaa738f88c5d39d97d52604fb5753761d01001d3ce432df"
    sha256 cellar: :any_skip_relocation, mojave:        "3e930645c90793a6678b2e3c4e5164f96381ae29757d618aa4bfdb889b65590a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4ba4311c3e23b7b619bbf42be97f47f114689311562db80e78abe5e2baef0738"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
      -X main.KubeServerVersionConstraints=""
    ].join(" ")

    cd buildpath/"cli" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end
  end

  test do
    system bin/"keptn", "set", "config", "AutomaticVersionCheck", "false"
    system bin/"keptn", "set", "config", "kubeContextCheck", "false"

    assert_match "Keptn CLI version: #{version}", shell_output(bin/"keptn version 2>&1")

    assert_match "This command requires to be authenticated. See \"keptn auth\" for details",
      shell_output(bin/"keptn status 2>&1", 1)
  end
end
