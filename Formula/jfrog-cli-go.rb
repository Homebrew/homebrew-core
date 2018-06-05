class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/JFrogDev/jfrog-cli-go"
  url "https://github.com/JFrogDev/jfrog-cli-go/archive/1.16.1.tar.gz"
  sha256 "8d000e7a37c1347e8011e8a39af148c70115ac03085075aa8bce9e3f3a076174"

  bottle do
    cellar :any_skip_relocation
    sha256 "2222d7a1f7fe9d7ef2bc4d6cb4203a86f607cf14a36d353821b0d4d9576bad30" => :high_sierra
    sha256 "b0a6ec94de0ee07da52fb606b8e0d1feed7a33acce9b5a6377c48b1fe89a87c9" => :sierra
    sha256 "3c00494920692a4f8e89fea0577487404eda47d92df087ffde142416aef51aa7" => :el_capitan
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
