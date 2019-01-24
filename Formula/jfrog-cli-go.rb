class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli-go"
  url "https://github.com/jfrog/jfrog-cli-go/archive/1.23.1.tar.gz"
  sha256 "a5200552acdf55592a6972900f2f658cb25dd6508793bc52fb3386a310a75414"

  bottle do
    cellar :any_skip_relocation
    sha256 "8aa4754e6b0e63c9039b2ffc1eeaefebb9b670573f61a0c1ceb4fe42b57efd2c" => :mojave
    sha256 "4383bb9bd85e514c7e47eb593f6e75261286611b0bec9271febc0ba49467f424" => :high_sierra
    sha256 "e304ccb046599b8afc89b3c0a9aab4b71d93f98611034c0efa8adf3b32cc67c6" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/jfrog/jfrog-cli-go").install Dir["*"]
    cd "src/github.com/jfrog/jfrog-cli-go" do
      system "go", "build", "-o", bin/"jfrog", "jfrog-cli/jfrog/main.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
  end
end
