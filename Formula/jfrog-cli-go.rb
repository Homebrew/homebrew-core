class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli"
  url "https://github.com/JFrog/jfrog-cli-go/archive/1.28.0.tar.gz"
  sha256 "b0018994ad68fb7e6ed3938f291b3babfb3d0e975c4c5b18b9e097b8d97b84e3"

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
      system "go", "run", "./python/addresources.go"
      system "go", "build", "-o", bin/"jfrog", "-ldflags", "-s -w -extldflags '-static'"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
  end
end
