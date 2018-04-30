class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/JFrogDev/jfrog-cli-go"
  url "https://github.com/JFrogDev/jfrog-cli-go/archive/1.15.0.tar.gz"
  sha256 "a04381aa96bcc74a6dbc9797fd4e8381af92c6cc2b049a349f360d99ebb90678"

  bottle do
    cellar :any_skip_relocation
    sha256 "8c027713da67346a3aed3541552fa2a90419f35c4d6da150fbf476571c22b500" => :high_sierra
    sha256 "977a382852c6204bd5fdc0c31a24f71e44402f2aa435b4c5b9ab56501576bb34" => :sierra
    sha256 "b0000acb35f2da01a8cbecb93069d22cc1f340a3517466a7fc210568698c5e86" => :el_capitan
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
