class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli-go"
  url "https://github.com/JFrog/jfrog-cli-go/archive/1.26.2.tar.gz"
  sha256 "9940a9537e7bd2bb93e0c8be63c134cc595ce6efd33830587b3e4ec9ad71395e"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8c2813df777263e27a88b185b7e1509b5cf0de1ed54b5faafaed6f40034b332" => :mojave
    sha256 "ac9fef1ef59d5fa10edaab96915525fe530deb117015e95eed526d5d3450ea8a" => :high_sierra
    sha256 "c8b1431e81244a00e66698e817cd46401b0467c8a76900f75fc7035b87019b2f" => :sierra
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
