class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli-go"
  url "https://github.com/jfrog/jfrog-cli-go/archive/v1.22.0.tar.gz"
  sha256 "c5e30cfb5d5795afb699db4aba466a7c6c4e35cd54a6353c505c598b72d3de57"

  bottle do
    cellar :any_skip_relocation
    sha256 "a91281eafc31d9940d7e031b62a177ee370c68c7f72f9442a49478e83c2f3003" => :mojave
    sha256 "caeb3dfb55d07b30dcc88ed6246fff83b8785000d07a59c7ec4ea65809ae174e" => :high_sierra
    sha256 "3bc26e2af76236ce5f5b0b70b642556a934a6fe23e22c9de9d97387bc4fff5e1" => :sierra
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
