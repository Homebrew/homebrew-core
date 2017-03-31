class JfrogCliGo < Formula
  desc "command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/JFrogDev/jfrog-cli-go"
  url "https://github.com/JFrogDev/jfrog-cli-go/archive/1.8.0.tar.gz"
  sha256 "f529559c900632ece646044fb25fb48ccc6f20d780148273585c667535b6fa88"

  bottle do
    cellar :any_skip_relocation
    sha256 "fd92fd28739c3667b2fb0ecbb60fbda37c7a1c420b9e82a8556de0d1c01e2457" => :sierra
    sha256 "e972bf3bfc67aa458f7369f5c61d063c19debb2e2e276528b1c8a710ce73cfba" => :el_capitan
    sha256 "955d383d75102b77d30c31a1d8a5b16c2010ed2346c2280c9a5557fd1edb06c8" => :yosemite
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
