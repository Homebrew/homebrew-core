class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/JFrogDev/jfrog-cli-go"
  url "https://github.com/JFrogDev/jfrog-cli-go/archive/1.10.0.tar.gz"
  sha256 "6eaf2b54ebb454e01fb289afa09e8cf4cf1f074453033e46e53f1aca7a91af5a"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f28ef693915d6f71f127755bdc8af9509807a0c5c1a455d50fa920e20376c34" => :sierra
    sha256 "1e2a8f3b33d28b242668b50e8359f698c7310780b2d0bd5cf2411ae0afed9302" => :el_capitan
    sha256 "7391096811bdb2bf78582ff57ac0329d1d74ab27b1da4124cb4f0f9e0198ff46" => :yosemite
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
