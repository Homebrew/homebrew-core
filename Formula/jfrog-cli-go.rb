class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli-go"
  url "https://github.com/jfrog/jfrog-cli-go/archive/1.18.0.tar.gz"
  sha256 "ff47adaa9b033fe43da5c165481cbaf216ab0f0714e8f23b8b3a81be3fdb2b5e"

  bottle do
    cellar :any_skip_relocation
    sha256 "814b10441aae57befa2125c5908bb15dc7c09ffe76507260549797264cda1939" => :high_sierra
    sha256 "1a024b6fdb13701ace5a6b993cbaa74cc9d0cb1377d90d5df60cd479f78b71c8" => :sierra
    sha256 "988d10f5237b8ee4860bfe1ca038f1b46afc041f4351d39d1c3db722f1a3e1cd" => :el_capitan
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
