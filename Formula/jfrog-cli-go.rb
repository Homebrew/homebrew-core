class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli-go"
  url "https://github.com/JFrog/jfrog-cli-go/archive/1.25.0.tar.gz"
  sha256 "830017909c884663a11afba1e2e07df3c387c17314327247d7ec336f0a52aa94"

  bottle do
    cellar :any_skip_relocation
    sha256 "eb470ca00e5d66ceeeac1e69f3f9380b6f742d78f079538d62553a9d646055a6" => :mojave
    sha256 "b5556e8f9ad509f4d743e833eec2851f8c4e76152085f7a48dcbadda7c0a55e5" => :high_sierra
    sha256 "84cfa6122767dadcef0326f18ae958e3ad188de9ebec06ec90517d64179f3fef" => :sierra
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
