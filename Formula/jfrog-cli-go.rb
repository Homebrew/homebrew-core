class JfrogCliGo < Formula
  desc "command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/JFrogDev/jfrog-cli-go"
  url "https://github.com/JFrogDev/jfrog-cli-go/archive/1.7.0.tar.gz"
  sha256 "0aa74b430e091454aeb409fd95eedc99a8c5472703ebdb783676af1e35a77efa"

  bottle do
    cellar :any_skip_relocation
    sha256 "31eda1135d9adb0bd602be4617598b1fff38489e25841cd108f208fe6ee469c6" => :sierra
    sha256 "cef1260f80905e9a0c81505f1f7d86519aaa889315e7953703858db7b3a7fc25" => :el_capitan
    sha256 "2c4f9b946fb5bd5df24596200193ef98f79c0199d0143bd8e627e5a98f285939" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/jfrogdev/jfrog-cli-go").install Dir["*"]
    cd "src/github.com/jfrogdev/jfrog-cli-go" do
      system "go", "build", "-o", bin/"jfrog", "jfrog/main.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
  end
end
