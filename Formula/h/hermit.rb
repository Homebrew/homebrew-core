class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://github.com/cashapp/hermit/archive/refs/tags/v0.39.1.tar.gz"
  sha256 "8be54680fb0965ed8fa45ea567fa860ccaf3e48f53b04fc82563ffc68def62e6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6e5da70a372a1118eb3d0114c32ed03914d7a63c9f0667a74b95787c92243d4b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a92243a9dcdd123092ae4e30909b8ce47e5b110393c7b50d3d4613b9d4a329c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "efde78dca5c28a3535babc9717a9bc784d32e83c917dfadb3e803068e4a13ba7"
    sha256 cellar: :any_skip_relocation, sonoma:         "330e68f237086d0d4b284579bbb8e14c003a191e974cc6dad4e2643cffe6b93f"
    sha256 cellar: :any_skip_relocation, ventura:        "f743dc441713fe9900fd37c364084e8d1d0c498d5ce0fbb228d6a3aa40e13000"
    sha256 cellar: :any_skip_relocation, monterey:       "cae01aed3465851aea3e0fce87027701bd3445aa1b4aca962c3a0992ebc1af6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3797c2d4ba34392e6dcbcdde6ab701ca94b31a0c5a881b04d3dde7bbea345a4e"
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
    assert_predicate testpath/"bin/hermit.hcl", :exist?
  end
end
