class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/JFrogDev/jfrog-cli-go"
  url "https://github.com/JFrogDev/jfrog-cli-go/archive/1.11.2.tar.gz"
  sha256 "b57f85205097c194d23dae07b225b492839ddf941e0711e7ebdc3e44b13d195d"

  bottle do
    cellar :any_skip_relocation
    sha256 "91302fdf1dece297b98b9b545057d215f760e096359f2a7a2bccc8b865e09e45" => :high_sierra
    sha256 "6a68425db646b5e971e883c13317e5376ec6a56a6af81a5c36979763625d839e" => :sierra
    sha256 "85c15f97d5c941f3747dc1e7e249a5d8b9a8f23c4b898d0a64ddfde51f1c56ca" => :el_capitan
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
