class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli"
  url "https://github.com/jfrog/jfrog-cli/archive/1.28.0.tar.gz"
  sha256 "b0018994ad68fb7e6ed3938f291b3babfb3d0e975c4c5b18b9e097b8d97b84e3"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2923b39b46f3a3d3ab994ddb5303c944cab3e27fd51f7cd41dfcd35b908af5aa" => :mojave
    sha256 "be2f1b972b0cd7d74f3976b2eb150b396d4f9d60955fc184f4bf4a561cc9c556" => :high_sierra
    sha256 "b48d0448c5f2d1f83a9f9cd46acd7d59b24d5857276e3360c5b0138b3696a75d" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GO111MODULE"] = "on"
    ENV["GOPATH"] = buildpath

    src = buildpath/"src/github.com/jfrog/jfrog-cli-go"
    src.install buildpath.children
    src.cd do
      system "go", "run", "./python/addresources.go"
      system "go", "build", "-o", bin/"jfrog", "-ldflags", "-s -w -extldflags '-static'"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
  end
end
