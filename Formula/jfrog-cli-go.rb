class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/JFrogDev/jfrog-cli-go"
  url "https://github.com/JFrogDev/jfrog-cli-go/archive/1.10.1.tar.gz"
  sha256 "d6a8ad0af6006d0d5074187eddc91daef740d2430cdeddb623718f45e6f4ec6d"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f118675b4bb243ae8c194e3d7830e60d10c4140a4e53a78dc8a0ac2b0294cc1" => :sierra
    sha256 "12d701253940708e8c54236e62b6317df603d004839bb8b9c6a8932c01c2c8a3" => :el_capitan
    sha256 "60eb2d1a6cfd44a4c9890c63171ad34a74723f7c5238dc4fbc673fbb2345a56d" => :yosemite
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
