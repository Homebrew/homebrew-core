class JfrogCliGo < Formula
  desc "command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/JFrogDev/jfrog-cli-go"
  url "https://github.com/JFrogDev/jfrog-cli-go/archive/1.4.1.tar.gz"
  sha256 "3d2e3850318ddc327ce7c6872452ae16613aece494dbe402d26e743c3b9146ce"

  bottle do
    cellar :any_skip_relocation
    sha256 "4487b0dfa48bd935119220f482ac0a6d87aa562bfe023b76a1938de0b6c9257a" => :el_capitan
    sha256 "9408e4220650360ae9d7dea4c4b1ac377befc72d615f758ff15542da70efefd7" => :yosemite
    sha256 "06abf34e20b3f719143181f1f775f4ab1d42a71a6754591f0f43a495f276e1bc" => :mavericks
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
