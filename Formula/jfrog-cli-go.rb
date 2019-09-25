class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli"
  url "https://github.com/JFrog/jfrog-cli-go/archive/1.29.0.tar.gz"
  sha256 "00a8849c63a6e4387f24864c43b4af2e745d5ce4567cd2a2d74dc1be9891308a"

  bottle do
    cellar :any_skip_relocation
    sha256 "00d510ebb018b90b15791c164d1e51e2f1ba5558c9c28518d962bd30cbc63537" => :mojave
    sha256 "121927bb889f68bab33c7e8e1f1612b54f6c1d7aae6efeab61b59e1875101469" => :high_sierra
    sha256 "2f83e848e40c71d3e17b2da5ed7ca1cdfa4f9df3b62e100ed646abb8d1b7cc8f" => :sierra
  end

  depends_on "go" => :build

  def install
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
