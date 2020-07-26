class JfrogCli < Formula
  desc "Command-line interface for Jfrog Artifactory and Bintray"
  homepage "https://github.com/jfrog/jfrog-cli"
  url "https://github.com/jfrog/jfrog-cli/archive/1.38.2.tar.gz"
  sha256 "1f4548918ff8ea9d524818c531aa8f63764f3bdb643b2515d170b53d664f2476"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "fc197ac4bd6c6825ad980b3b7037ca0871db3174249a5a3af554ff2cb672f986" => :catalina
    sha256 "c4470c1890aa0b0e72a2827518220057d2130138234a384d837f4f17927b7a02" => :mojave
    sha256 "990aa09aefbd56bdc4bb0f8e6ddbdcf655668a1d99285fa9dda76004ebdc2e3c" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -extldflags '-static'", "-trimpath", "-o", bin/"jfrog"
    prefix.install_metafiles
    system "go", "generate", "./completion/shells/..."
    bash_completion.install "completion/shells/bash/jfrog"
    zsh_completion.install "completion/shells/zsh/jfrog" => "_jfrog"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/jfrog -v")
  end
end
