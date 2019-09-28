class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli"
  url "https://github.com/jfrog/jfrog-cli/archive/1.29.1.tar.gz"
  sha256 "2cd2e26088505b45dfb3b4e0a60a6aae90eca38dad124ecfe832b143b08a4dec"

  bottle do
    cellar :any_skip_relocation
    sha256 "00d510ebb018b90b15791c164d1e51e2f1ba5558c9c28518d962bd30cbc63537" => :mojave
    sha256 "121927bb889f68bab33c7e8e1f1612b54f6c1d7aae6efeab61b59e1875101469" => :high_sierra
    sha256 "2f83e848e40c71d3e17b2da5ed7ca1cdfa4f9df3b62e100ed646abb8d1b7cc8f" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath

    src = buildpath/"src/github.com/jfrog/jfrog-cli"
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
