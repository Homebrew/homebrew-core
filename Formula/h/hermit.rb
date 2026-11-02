class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://github.com/cashapp/hermit/archive/refs/tags/v0.55.1.tar.gz"
  sha256 "5dabb1586e1797d409db4d398f5f612d9af9f46a1e805a9f93423961c8fa091d"
  license "Apache-2.0"
  head "https://github.com/cashapp/hermit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "61e2e16646fa548a5524fdcf04e86618082e59385619d503c21e5b48d701c8e8"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "b1b844c6593d696e4c8be6dc7a88b6d17fe856578c4efc6cc7b31057384e7752"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4ad52cb56d401c7cd1a82d55670ee6910fb2041db88771d29dca199da2785372"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "ec8d067e3fe87f78914ed02ef60ca892af36f6110341513fa5a48c0be5273cf4"
    sha256 cellar: :any,                 x86_64_linux:      "d44d01eadbd34ccaebed902a4b1940fd1fc47e992be2fe9760cefc523bca4a9f"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
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
