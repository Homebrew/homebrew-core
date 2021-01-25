class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.1.24.tar.gz"
  sha256 "6c77cd87914d4200d2777886ed3a793db1094cacc54f40d65ab7cf98acc914c1"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "63989e68781a118a30426e3be6d8436999ba4b19d58c0924b9c5477209c76e5e" => :big_sur
    sha256 "bb4b68220d1ae0c081ef18528b0933d1d46c1b6d632b18ea82ce9d9b2ec80a93" => :arm64_big_sur
    sha256 "42ec0cda2feffb1954e087daf9b753760b6aa295e71525e757f95f03211b4c34" => :catalina
    sha256 "f6dd1f92ce9e959e96c8e1a4379b06d1618404b99f7e145b5fdad7f76c0a8adf" => :mojave
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
