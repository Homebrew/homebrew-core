class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v1.49.0.tar.gz"
  sha256 "2135019d7b94f1848e3c47be006effbf22698278d5a30ce47687ae5451d36a0d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1ce41d58517afb008b098402f25e705f04f7a25391b5a1445995cfb687b605bb"
    sha256 cellar: :any_skip_relocation, big_sur:       "c5d3c20e3f6b3ac23dfd13aa19a6115e50265e7be358fadc1e940d2f0c7052b8"
    sha256 cellar: :any_skip_relocation, catalina:      "807c6bd2e19b7daf706f59dbe56498240dbb6be274e56d77a5c8c53a6008532e"
    sha256 cellar: :any_skip_relocation, mojave:        "92823f362dfda4476bd11b51c29e057a383032236f38b1db46c558f06442a766"
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
