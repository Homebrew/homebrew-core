class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli-go"
  url "https://github.com/jfrog/jfrog-cli-go/archive/v1.22.0.tar.gz"
  sha256 "c5e30cfb5d5795afb699db4aba466a7c6c4e35cd54a6353c505c598b72d3de57"

  bottle do
    cellar :any_skip_relocation
    sha256 "0f0ea64795cd0d026d478468aab27cffb02969400ce187ba315af562ea550012" => :mojave
    sha256 "2f81e114dc0320ca40c7ca0b953b92558e7233e51e1acc7a061a04bcce5d1bc8" => :high_sierra
    sha256 "669868ddef442d80617dc61faad4e2ebd00cd01f0a3d20ed66da0aab8dde62f0" => :sierra
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
