class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli-go"
  url "https://github.com/JFrog/jfrog-cli-go/archive/1.26.0.tar.gz"
  sha256 "ce7e08f12992a8b868f3644dce53a79a44034f9656d600554ea1997a6937954d"

  bottle do
    cellar :any_skip_relocation
    sha256 "3182c0a983dabd1c762d00c8075789ad6fdc9009996e50a2c523e4b66efec643" => :mojave
    sha256 "6394dcca92759a3bd9b4606c9cf5ba6b04a5d650827d04a637279ae45cfea9f9" => :high_sierra
    sha256 "ae8334896e963ac994edeee4572bbb9602a9f089c797b5e31533ce22f11bdfb9" => :sierra
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
