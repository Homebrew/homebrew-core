class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli-go"
  url "https://github.com/jfrog/jfrog-cli-go/archive/1.20.2.tar.gz"
  sha256 "167c04a56e580c818c1e1cd829926a5b0641f8b0b06a92dcb8d085f956e21138"

  bottle do
    cellar :any_skip_relocation
    sha256 "579acec171c68ecd68bded962ff74afd55b9ba1262346fa7c02d242b928bc953" => :mojave
    sha256 "21da0682656c1a3b21777db37494e068265c204d2b177ca9b81a6e18f6e12482" => :high_sierra
    sha256 "365fc4b8974f7eb45c54b72660e557bd6082e02388203ec726f5722c0b1ba5b8" => :sierra
  end

  depends_on "go" => :build

  def install
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
