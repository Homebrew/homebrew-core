class JfrogCliGo < Formula
  desc "command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/JFrogDev/jfrog-cli-go"
  url "https://github.com/JFrogDev/jfrog-cli-go/archive/1.8.0.tar.gz"
  sha256 "f529559c900632ece646044fb25fb48ccc6f20d780148273585c667535b6fa88"

  bottle do
    cellar :any_skip_relocation
    sha256 "e7c5447b8657d442714ef919fbc1e4050b1634eeb4b5e82cf712634198f2b82d" => :sierra
    sha256 "89923187cd244ba33ae73acb22bf2b8e54062f6f9462f9d8e1d210b6f828cf50" => :el_capitan
    sha256 "22b9e1a796548ef01536062de5e7f19dfe3f3d269750ff2e98a34dc813f712bb" => :yosemite
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
