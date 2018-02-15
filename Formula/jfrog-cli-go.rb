class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/JFrogDev/jfrog-cli-go"
  url "https://github.com/JFrogDev/jfrog-cli-go/archive/1.14.0.tar.gz"
  sha256 "6551f06eaa4b2b476de6eac396352550f43084ffe1b07cebd60421015a2cddca"

  bottle do
    cellar :any_skip_relocation
    sha256 "712b7ae14f2006f450c13cb006dedb595d044acab8c9417f67cbb51c21e655a2" => :high_sierra
    sha256 "5e123128079e1132d0284be0ccd79321e3b8350bc6616b628fc4c6a8cd448ac4" => :sierra
    sha256 "756f7dd9aa7776aaa7807d2f719f7cc647748f3790c3747966c38569db637271" => :el_capitan
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
