class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://github.com/cashapp/hermit/archive/refs/tags/v0.56.1.tar.gz"
  sha256 "5522cecffb059e9a55ad68e9093f37fdfe0b0b1a3f3b136143e29e91d2e6aa70"
  license "Apache-2.0"
  head "https://github.com/cashapp/hermit.git", branch: "master"

  bottle do
    manifest_sha256 "6a793e4c2c5b0bff159882e1fe1cbfd4d7066c2ec37f6d0d2eab7cd62c148791"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9ac9962745abea31e971b07a7635b06b89e7b045dd6bdef688b6f48955caf381"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "c270c9e219e27445fa801865735462e910d0827543f34ec499013fa4d77cfe7f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "261692c652c4abdec4a609dc6d19d18f8ea35a7b68965877af543862ebb1730b"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "14ddbddeeb64a97a78eda262a827fe2247f37e4990b6038c7ead98a4815e0003"
    sha256 cellar: :any,                 x86_64_linux:      "a16a77f1cd3b5497db1098bc9858f12aa238ed8aba422c34a367aa8d6dfab455"
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
