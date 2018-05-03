class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/JFrogDev/jfrog-cli-go"
  url "https://github.com/JFrogDev/jfrog-cli-go/archive/1.15.1.tar.gz"
  sha256 "2c6e0527adcf572ecaa9faa1738e40bbcb97578c45d85c97c4aab2ea0c80d5b6"

  bottle do
    cellar :any_skip_relocation
    sha256 "8c507212b773e0c1e38378f74a93b563c9ff080cce440a9488894029af2bd39e" => :high_sierra
    sha256 "e8e73d33a8809dc33e45f4d53d108a08494558ffbeb1b2106f7ba3bfd2d67abd" => :sierra
    sha256 "615575ee6d73eb8baad363cf57310925cf9dbce054c8741fc0f576e8cb9054b7" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/jfrogdev/jfrog-cli-go").install Dir["*"]
    cd "src/github.com/jfrogdev/jfrog-cli-go" do
      system "go", "build", "-o", bin/"jfrog", "jfrog-cli/jfrog/main.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
  end
end
