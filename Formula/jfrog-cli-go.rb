class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli-go"
  url "https://github.com/jfrog/jfrog-cli-go/archive/1.17.0.tar.gz"
  sha256 "da21779ddeea24b9760e2d175e8516ea845a143e23cdb8f9790f6909b1eff7e7"

  bottle do
    cellar :any_skip_relocation
    sha256 "c614a394801f44fd3cef7837d70df88e3c42e28b7de510d3f503785dfd6e1dac" => :high_sierra
    sha256 "df78eccaa7aa1a8f156e0196f38eed28df803b0245b378015f12ad74ec7614c5" => :sierra
    sha256 "b11baeff9b09975d92cf20059190d4fd7d56d5b4aac0d01884052ea1a086bb6d" => :el_capitan
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
