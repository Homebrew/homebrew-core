class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/JFrogDev/jfrog-cli-go"
  url "https://github.com/JFrogDev/jfrog-cli-go/archive/1.10.3.tar.gz"
  sha256 "4a0bc9366e5decaa770f58c06e20a0a78ac6357eb4fdd6816edb28602e2a58ac"

  bottle do
    cellar :any_skip_relocation
    sha256 "7a56b7b88bd98a5055b6961baa8ee6bc4c6e7d7e82046e1dd5c912d7efefb88e" => :sierra
    sha256 "f43ce6f1484e34c56998ecce1778a3d04122e111b974a48e1d07fae8db48d048" => :el_capitan
    sha256 "47eab52c33f93b193b4724a6fecdc72178381c39fc6a18e8a12f47f2950bd701" => :yosemite
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
