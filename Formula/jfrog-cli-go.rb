class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli"
  url "https://github.com/JFrog/jfrog-cli-go/archive/1.27.0.tar.gz"
  sha256 "b071e3ef9bcd67694868f3b79069fda74c0978c6de3ab6d312f89232778b1294"

  bottle do
    cellar :any_skip_relocation
    sha256 "afd73e05046d555d28ced76887cb2bc479983343773f21ec975324bf5f31a2f4" => :mojave
    sha256 "3d9e468d26ab11359fe0a19c5edd58dff5b820bb88b1ab044873e1983b100321" => :high_sierra
    sha256 "1caef75ada6ea45203f7db748e1fcd56c22acb67f8077256eb4e6165e8b883cb" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/jfrog/jfrog-cli-go").install Dir["*"]

    cd "src/github.com/jfrog/jfrog-cli-go" do
      system "go", "build", "-o", bin/"jfrog"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
  end
end
