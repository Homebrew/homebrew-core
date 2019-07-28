class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli-go"
  url "https://github.com/JFrog/jfrog-cli-go/archive/1.26.3.tar.gz"
  sha256 "3248e06e079b27cb40a71320be0977d47e3fe94090175b91662bb1fc7e7ebb06"

  bottle do
    cellar :any_skip_relocation
    sha256 "8407af4552d5b8203701171afdf96f000c23e8dbe594a8fe0290657dfde46b2c" => :mojave
    sha256 "631e97e547ff25c0cb4754bc01de9b468f638ac3ecc9d2565534ec6b46a13448" => :high_sierra
    sha256 "1ef396862743a381f9d4ee7694c348e77e407a52608ba15fad5386058dc067d9" => :sierra
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
