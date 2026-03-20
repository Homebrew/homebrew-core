class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://github.com/cashapp/hermit/archive/refs/tags/v0.50.1.tar.gz"
  sha256 "e3a43639b398487944ff508b4c8cc869140fdbbced6fe588b244afd5a02dfcca"
  license "Apache-2.0"
  head "https://github.com/cashapp/hermit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f6e8029fea8383ab5a830320d2276e5e05713a50d526fa5110f5f365bd6c784a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "57625ee4de08939d5fdd2c3ee2f4a7bb42831195c75a89527738ad377cbe6651"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "afb8476cc01c2220483d14757a2ac9319914a86e39af9131e29b0b27b4097db0"
    sha256 cellar: :any_skip_relocation, sonoma:        "8a6725cd5996592c9089d26466308478db2b7e177b4be1a5ee0ce96e454ed021"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45eb1ec2f373ba46dd75bae2f07741f89973451a8740c25b70da2678efa5e91f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "431135fdfafc23816f816d94e1fb5fe47f1e9e174fcb650bac99b38f7a0a359e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.channel=stable
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/hermit"
  end

  def caveats
    <<~EOS
      For shell integration hooks, add the following to your shell configuration:

      For bash, add the following command to your .bashrc:
        eval "$(test -x $(brew --prefix)/bin/hermit && $(brew --prefix)/bin/hermit shell-hooks --print --bash)"

      For zsh, add the following command to your .zshrc:
        eval "$(test -x $(brew --prefix)/bin/hermit && $(brew --prefix)/bin/hermit shell-hooks --print --zsh)"
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hermit version")
    system bin/"hermit", "init", "."
    assert_path_exists testpath/"bin/hermit.hcl"
  end
end
