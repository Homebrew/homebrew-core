class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli-go"
  url "https://github.com/jfrog/jfrog-cli-go/archive/1.24.1.tar.gz"
  sha256 "d8c0dfc47dfec08bf92e35bbaf21844503c30aa772ca8fbc3acafa73aa8582ec"

  bottle do
    cellar :any_skip_relocation
    sha256 "4051a923ec044fa5f21cb78c7b6bdf95007a969f427dae5986fad3fcedab8d95" => :mojave
    sha256 "4d3abf41c0c60d08fcd8ffd844e5b904239f3cef3b58dab521e1f9efdc30ba81" => :high_sierra
    sha256 "498818bf0d440ba9aa5a3515afe98310fc2342ac6da8c0d5da2a639cba98b990" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"
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
