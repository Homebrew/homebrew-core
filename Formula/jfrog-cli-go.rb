class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli"
  url "https://github.com/jfrog/jfrog-cli/archive/1.29.1.tar.gz"
  sha256 "2cd2e26088505b45dfb3b4e0a60a6aae90eca38dad124ecfe832b143b08a4dec"

  bottle do
    cellar :any_skip_relocation
    sha256 "a229008ce2afbc5ab94f9016ab0d317bf224163cdd6044dfbb694d9f5f1ea08e" => :catalina
    sha256 "4a1468600c6c34929b4b166a197519ea7c9f2b5b6c74522000b210d85c94cdfd" => :mojave
    sha256 "77631ca79277bca59c033d923818b6c36931e139a4e0a3ef6589eec6a522a6ed" => :high_sierra
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
