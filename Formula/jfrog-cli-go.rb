class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/JFrogDev/jfrog-cli-go"
  url "https://github.com/JFrogDev/jfrog-cli-go/archive/1.16.0.tar.gz"
  sha256 "0a6d6e1ddf015782e6545b4f5d5b440ca7a4ab4e56baac66fdd9258ba9ea74dc"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f763e0137f06787184d5f7ab9b22842e72655e6b9a7cbe6ea2699d9a7a6d49e" => :high_sierra
    sha256 "4e88d9bcb7237b9f8e9d19d8d0158f03b9c5ec12d3e61edf885658641be98345" => :sierra
    sha256 "7f175b5d3f439f6119ad01c190f3d6a74d163e98d08fc0c5ff545af5aee5a1c9" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/jfrogdev/jfrog-cli-go").install Dir["*"]
    cd "src/github.com/jfrogdev/jfrog-cli-go" do
      system "go", "build", "-o", bin/"jfrog", "jfrog-cli/jfrog/main.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
  end
end
