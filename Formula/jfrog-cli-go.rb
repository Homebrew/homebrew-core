class JfrogCliGo < Formula
  desc "command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/JFrogDev/jfrog-cli-go"
  url "https://github.com/JFrogDev/jfrog-cli-go/archive/1.6.0.tar.gz"
  sha256 "5da5e904ee1a46c367652a9df4f4787a63fa9ec5934f44698f3aae7e8bc25680"

  bottle do
    cellar :any_skip_relocation
    sha256 "403bb836508043cda9061a25f501311f5f09de07fc621a8738524bbf50c4963d" => :sierra
    sha256 "babcac7e3f20b774740aa682d61660cd8ae7d2972e5dc0be01f1cd6ac0812a53" => :el_capitan
    sha256 "15dfeea15a443ae02ec6d579783ae9536c4a15e124eda7f4468842458bf3075f" => :yosemite
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
