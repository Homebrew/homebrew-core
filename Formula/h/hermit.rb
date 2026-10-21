class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://github.com/cashapp/hermit/archive/refs/tags/v0.54.1.tar.gz"
  sha256 "2121aabf57b62c9728f7f3319ad5cc6e4724be8c303b2302828d2bafd05f040e"
  license "Apache-2.0"
  head "https://github.com/cashapp/hermit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "965775a1063d4bb1f352522b1201a16c4e0629784e24ca45b40236ddbe2f1418"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ad7f8a45d513b1326a2bee9350a51b9266645e316343617b80c0048141a3ffc1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "994a92122d89909cabdf1b464d3c2def1d08889c83549f5d0514d94b3271c692"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "e9b37b752a6707ce0222610d57a40161f6f6d4ced9e01be23e5b848623779848"
    sha256 cellar: :any,                 x86_64_linux:      "2f8e68fcd03996517e3309dc2c0f5c5975acd39d72ac85483cfb9c8c86163aec"
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
