class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli-go"
  url "https://github.com/jfrog/jfrog-cli-go/archive/1.19.1.tar.gz"
  sha256 "e1329d1023abade5740ab1f43fc26c20b27e498e9cc54f64cee19f20f398fe95"

  bottle do
    cellar :any_skip_relocation
    sha256 "1baf80e2c1c8c4c58a7c87fed3046d2a6e283892e487bef2954d8660e6636059" => :mojave
    sha256 "99c1e5ae7dc4bf79d01b2f391677425d9fc2507a0da2af0c39767d4fdbb7f9dd" => :high_sierra
    sha256 "22853a04ef554d64417a7bfe9b15785152d1350516a251eeee4a8bb55034825d" => :sierra
    sha256 "80a79debe47ebf1b33eb608558648c96ccfd576b81944db5801412096e966fd7" => :el_capitan
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
