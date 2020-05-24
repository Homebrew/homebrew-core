class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.1.18.tar.gz"
  sha256 "75199d903edc5e2a33f024ea169fe5a3a2fcdf941b4450d4d93f47f0114d57fe"
  head "https://github.com/gruntwork-io/cloud-nuke.git"

  depends_on "go" => :build

  # go modules PR, removed in the next release
  patch do
    url "https://github.com/gruntwork-io/cloud-nuke/pull/115.patch?full_index=1"
    sha256 "dd14092b2222dcca60dd34e7f839e4033c71e773e1c079ecbec41c70860bfe88"
  end

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
