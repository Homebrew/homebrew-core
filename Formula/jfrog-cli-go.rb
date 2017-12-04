class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/JFrogDev/jfrog-cli-go"
  url "https://github.com/JFrogDev/jfrog-cli-go/archive/1.12.1.tar.gz"
  sha256 "f3d537be1f680fe1701f9abf2adce4b490989f560000cb9aa7feb99d38e4e0f8"

  bottle do
    cellar :any_skip_relocation
    sha256 "21abb1282b1c3cf251cb70ed2d143ad1db8a46046ac6dc10055b2b801d59165a" => :high_sierra
    sha256 "243a6bd8f0eba37f346f9e99a58954ad20a55ea40f7ff73d3f67c17d39323182" => :sierra
    sha256 "ec0fdc9463709a60af0552f68b8fd30fb0e9d21b131a51427c170de482d2dba4" => :el_capitan
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
