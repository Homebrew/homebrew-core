class JfrogCliGo < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli"
  url "https://github.com/JFrog/jfrog-cli-go/archive/1.31.2.tar.gz"
  sha256 "a847556ff171475d661329c2e71c3f61774da2ff2f0418fae7d16f5dbed4a70a"

  bottle do
    cellar :any_skip_relocation
    sha256 "1bbce445b49dc74a15b536db4a14ee0e52e714eb5d9b3f3d7d2acd664960c865" => :catalina
    sha256 "78f9b4cce8940e0adc84f2f407d0e99f8ed6b040301a22031795c019c6abe00b" => :mojave
    sha256 "86789a4abd3e8959ab40224c9c39c4acf6d74820aa8faa9c426ff1c31245251c" => :high_sierra
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
