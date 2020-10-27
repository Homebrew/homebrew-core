class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.1.23.tar.gz"
  sha256 "5d68710dbae7cde1da0b7c7ab13f70a4cbf28af5b36e25e3d3b1808d7228ac80"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ac2f1a0c8c8ad02cc0fb1244ea067ee158f9073a254c06dbe118366b2ae26b7a" => :catalina
    sha256 "21ebf7a8ab689ff06593b2b1c28eb22e9e0cfa2d97db33542a793a284a35f222" => :mojave
    sha256 "7f4a022d959addd1e994a471cdda468faa790cde402a32f299772a5eb60ce451" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=v#{version}", *std_go_args
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
