class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli"
  url "https://github.com/JFrog/jfrog-cli-go/archive/1.30.2.tar.gz"
  sha256 "cd075e0793bcba0cde19bd300d2804b9c9aede09b5772f14f02926609dee55c5"

  bottle do
    cellar :any_skip_relocation
    sha256 "2ef543e216e4eaa89a75747b9620ba376cddc0e7dc44bb56f7db8474534a80f5" => :catalina
    sha256 "565c1390b2ce0f515312629510634728465e0fda846d5f3c15bb6aa4d64b09d8" => :mojave
    sha256 "7f631ce149af3fd5298c651ddf2f32103f909131204b82bd52ca51dd019129bc" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    src = buildpath/"src/github.com/jfrog/jfrog-cli"
    src.install buildpath.children
    src.cd do
      system "go", "run", "./python/addresources.go"
      system "go", "build", "-o", bin/"jfrog", "-ldflags", "-s -w -extldflags '-static'"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
  end
end
