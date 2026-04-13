class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://github.com/cashapp/hermit/archive/refs/tags/v0.51.0.tar.gz"
  sha256 "65b0bd1829bc09909b4963850c28154381fb96aa08b8345ce675f1e6921493ec"
  license "Apache-2.0"
  head "https://github.com/cashapp/hermit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f38d023246a8396d6345e3dfb82804343eb27100a941f31269f3119bb31738a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0aeaf3ce3543e4baf96d86938a259f2e0439fc981a3c75348d78ac135edc03db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1596dbac45c12fec843089cb4bda88ffd088b150d8240673b5581aa0374b9437"
    sha256 cellar: :any_skip_relocation, sonoma:        "3c9a90213731cacdb85ceb55d3045ae3da06174405ae1e381ae4500ba4853328"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9e00b40f583be068fb4b7b07dad971b3aa5e58f9d94a6c45ddf922df85d476b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "110e02db3fde00cddd93eeea8e597a0d59ca822a0fc846e91b393e1ce180bfed"
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
