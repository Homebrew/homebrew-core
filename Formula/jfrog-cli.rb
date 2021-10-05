class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v2.4.1.tar.gz"
  sha256 "0873f5848823f6ed30cfc244ec975e63bd64eb5f6c8b7e69e5391331db780515"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5c062b09d3694a62897950243dca460ac566bdd8de494d7218a754730fb8a07e"
    sha256 cellar: :any_skip_relocation, big_sur:       "397e90940d4d2708d10424d0bf7d7bdb827a539d569a5f8cf161b83be992f9d5"
    sha256 cellar: :any_skip_relocation, catalina:      "6a1546569755ddaf58e04c25e57c5dfec11dc873798118c315f29a6c8362185f"
    sha256 cellar: :any_skip_relocation, mojave:        "db4009d0c74598eeb2eeb3d3aca9b29becb4c62514e6590629f5299a628840f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f3ffa51b6b19c936001305667513475a55836832e37ac715afc7264dd19667e"
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
