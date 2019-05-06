class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli-go"
  url "https://github.com/JFrog/jfrog-cli-go/archive/1.25.0.tar.gz"
  sha256 "830017909c884663a11afba1e2e07df3c387c17314327247d7ec336f0a52aa94"

  bottle do
    cellar :any_skip_relocation
    sha256 "a58330ef1b5706813e0eb96ff012d7204ec1ac6eed675ca99dd3012dc0ac7986" => :mojave
    sha256 "e37cffd00b61227d624f274f4bddf1694d809c30d63cf527681e0b319d2f426d" => :high_sierra
    sha256 "94e59e5cfc2b7e49634382ac9695a754d01eaa7ab2179ebcb7890846494fadb1" => :sierra
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
