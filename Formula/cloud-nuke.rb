class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.4.0.tar.gz"
  sha256 "18cc93a7245420ed86dedf5a604afea238e6bde953ea4e938b0c43939c59c5ab"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8217bdcf73183837cbb9b9fb36ca20ea5f19954705d5d4dce76dd2b6b3579d3d"
    sha256 cellar: :any_skip_relocation, big_sur:       "a9cfc97d98c8aed64662f8d4cf7981f701a46b70919a06a5fa651bd6f33d58be"
    sha256 cellar: :any_skip_relocation, catalina:      "dfcb3e982dced216ec225edff2a29e8d4eb3d1d2b55ec8105af43f1eab42f443"
    sha256 cellar: :any_skip_relocation, mojave:        "0273736dec55fc74114c34ab650a4bad25f70a6fdb04f08749d4a8dd52ddc679"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52c21a7bb29a70a2b485d483d41869c70731702a9d198176e3567b48a943f6a7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.VERSION=v#{version}", *std_go_args
  end

  def caveats
    <<~EOS
      Before you can use these tools, you must export some variables to your $SHELL.
        export AWS_ACCESS_KEY="<Your AWS Access ID>"
        export AWS_SECRET_KEY="<Your AWS Secret Key>"
        export AWS_REGION="<Your AWS Region>"
    EOS
  end

  test do
    assert_match "A CLI tool to nuke (delete) cloud resources", shell_output("#{bin}/cloud-nuke --help 2>1&")
    assert_match "ec2", shell_output("#{bin}/cloud-nuke aws --list-resource-types")
  end
end
