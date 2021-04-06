class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.1.28.tar.gz"
  sha256 "0b340e5225d701bac9107374b8341b0f50e06e0dddbeab710bf8b97128d59f1b"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "339a98129a01189aa4191aa5402cba30271b5de5ec853810686b2b57c844172c"
    sha256 cellar: :any_skip_relocation, big_sur:       "7f26d46d0555f41e698bb77795726e6c44a6c2244e8a564fdd2353e00a01cf75"
    sha256 cellar: :any_skip_relocation, catalina:      "e11f6e01ec24ad620f0a6aaaa955050dec7e699e11ba4e1b41792f163087e2b9"
    sha256 cellar: :any_skip_relocation, mojave:        "4661109d3d0107abdc73a9314852b9d661cb17bfa2f4ba0187c99263564c42a0"
  end

  depends_on "go" => :build

  # remove in next release
  patch do
    url "https://github.com/chenrui333/cloud-nuke/commit/5f2919c.patch?full_index=1"
    sha256 "049a8e9dfc5715c8cb322b53ea76f17192ba46342a0d09cd39d78324ba138cfa"
  end

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
