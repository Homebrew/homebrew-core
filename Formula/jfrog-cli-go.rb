class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli-go"
  url "https://github.com/jfrog/jfrog-cli-go/archive/1.20.2.tar.gz"
  sha256 "167c04a56e580c818c1e1cd829926a5b0641f8b0b06a92dcb8d085f956e21138"

  bottle do
    cellar :any_skip_relocation
    sha256 "678ed4db481bfe0fd89932afc0d9d46479cbf8f000f63d6aea3e87ab4c195e2d" => :mojave
    sha256 "a941d570d1261e2035013e59071472ae85789ac0ad7a6ecb1cb40f4a87f8f83b" => :high_sierra
    sha256 "a0f77f12376a5bcd0c1446891727d1034752891a07f3eca4f0d9d03aa37c192d" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/jfrog/jfrog-cli-go").install Dir["*"]
    cd "src/github.com/jfrog/jfrog-cli-go" do
      system "go", "build", "-o", bin/"jfrog", "jfrog-cli/jfrog/main.go"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
  end
end
