class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli"
  url "https://github.com/JFrog/jfrog-cli-go/archive/1.34.0.tar.gz"
  sha256 "4236b2872b69c8f7c3cf2fdbb821b65b84f117257712f7b192aae295d81eee1a"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b19208a26a956c51c1f3648afca055840f9e4b8f9e0aa07faa5b476bb17b2d2" => :catalina
    sha256 "5553b94e38b1ad9865a085f1fc76b543713e6cc7a229669b3b542fdcae2d3a6e" => :mojave
    sha256 "61f17ba4dcd860d8f50a9130056a7b004f64b3a0c8aef8527df8fe0e102e0b0b" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -extldflags '-static'", "-trimpath", "-o", bin/"jfrog"
    prefix.install_metafiles
    system "go", "generate", "./completion/shells/..."
    bash_completion.install "completion/shells/bash/jfrog"
    zsh_completion.install "completion/shells/zsh/jfrog" => "_jfrog"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
  end
end
