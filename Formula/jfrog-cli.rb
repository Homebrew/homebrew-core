class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v2.1.0.tar.gz"
  sha256 "8f95898a954ec4df8bd41c043d2f0cbf9d31322155e8e213bdb978e784e811f4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b69eb620b47bbf6d2f4204199126b40c8f3279331f2be6434367c858da2fdfac"
    sha256 cellar: :any_skip_relocation, big_sur:       "484e41483de267892b3b87aceb84d5040cd66df4db4ced30de419f8e32011a84"
    sha256 cellar: :any_skip_relocation, catalina:      "82bb93349caa162aeaa8dcfc1d656b26c09402c3afa721d424e7d2bfd5f19390"
    sha256 cellar: :any_skip_relocation, mojave:        "646eabc0a7de10ced94fd53e86b9d641cab90795ea2a88a0c0a4702db66e8788"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9d49e21304da60789171634ba6748db0b4a8ae4224d409f823982c8f458144f"
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
