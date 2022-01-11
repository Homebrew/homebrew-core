class JfrogCli < Formula
  desc "Command-line interface for JFrog products"
  homepage "https://www.jfrog.com/confluence/display/CLI/JFrog+CLI"
  url "https://github.com/jfrog/jfrog-cli/archive/v2.10.1.tar.gz"
  sha256 "e847b6ae26a7915e093b5667c7cd2d9a256a97cd3f9240b7aa118f7fd22f38af"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c450627386cdcb047ed529e55e1b81b10f41135e2af61b65eb6cc92413cee793"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5657fc3173165d8fefe655850c7793dfaad843a563a07b7dc17f78c8b3c2f4b"
    sha256 cellar: :any_skip_relocation, monterey:       "f5e238fa7ea79f0983053fc86b2faf15d9aa58bd5dd5d14c8241ca4ab5f16f8a"
    sha256 cellar: :any_skip_relocation, big_sur:        "1584002411ba79c81ffa68ac0ae4fe2ae5b5c28a5749735cf68de726ddc1b9c6"
    sha256 cellar: :any_skip_relocation, catalina:       "6364407c34d375b5d533a3255a79cd4dbfb1fec58baf9fb1de0c5ec503ab2ab9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55308ad6073c11a05bcbba0bcc69b70285277a9ce1d8df5e540f7862b29a3b6d"
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
