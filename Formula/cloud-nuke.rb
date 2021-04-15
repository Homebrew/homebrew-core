class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.1.29.tar.gz"
  sha256 "329c672a81e08cbeb22a76c83b206261a3e0a5b3f03d58f329071e9dcef411e7"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d772a2fcc42edf5d261ad1d5db1f74072a4f338113b13310148d031044947757"
    sha256 cellar: :any_skip_relocation, big_sur:       "0a3006a15339496722b2684a0182bf9a3a4476e262537241a6b2c1e672336d8b"
    sha256 cellar: :any_skip_relocation, catalina:      "53c5f51da880eed525f075175590f686b9930988ba1958c70d559a75d0a0ca84"
    sha256 cellar: :any_skip_relocation, mojave:        "a389687bdc57eef665e006f73d100483cdb2045662dc967ab2031731a874e3a8"
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
