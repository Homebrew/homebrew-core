class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli-go"
  url "https://github.com/JFrog/jfrog-cli-go/archive/1.26.1.tar.gz"
  sha256 "b092d4133c3f84a9565dfcc0defb05dfc941653e11ebde17ad1f819dae0b3461"

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
