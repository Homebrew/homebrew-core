class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/JFrogDev/jfrog-cli-go"
  url "https://github.com/JFrogDev/jfrog-cli-go/archive/1.11.0.tar.gz"
  sha256 "7e743d6a203a36bcc2b799412e601963a7c69b13283d5f3de8327492b3f86085"

  bottle do
    cellar :any_skip_relocation
    sha256 "91d084f32c3e2362eb19305ada0eff36185e4a380c2ade587d4df892d63469e1" => :high_sierra
    sha256 "8a56c17abae144f59821f04f837fea1529ab2ec6e22df7c83254083592cc5848" => :sierra
    sha256 "27072ca98e5592f2201e402e14cf5d27b60d1030bc2922b7eaa0641953ca601a" => :el_capitan
    sha256 "887079198d50d118194add5c7e23bfcb91afcbb3a67ac07a13b5225f54468090" => :yosemite
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
