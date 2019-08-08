class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli"
  url "https://github.com/jfrog/jfrog-cli/archive/1.26.3.tar.gz"
  sha256 "3248e06e079b27cb40a71320be0977d47e3fe94090175b91662bb1fc7e7ebb06"

  bottle do
    cellar :any_skip_relocation
    sha256 "27bd320786b2adc3d2f378535e39dced2aacbd17b615c89661a5ce1ab4c955db" => :mojave
    sha256 "4eb1ac7f3b9d690314aea547a2624bb340062a2bb6fb6782e2e09b83f646797e" => :high_sierra
    sha256 "6e20e3336cc7349f8071feac47d644e5fc5854b8e05e57915211a12aa4d17aaa" => :sierra
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
