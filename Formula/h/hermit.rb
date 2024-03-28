class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://github.com/cashapp/hermit/archive/refs/tags/v0.39.0.tar.gz"
  sha256 "b4f1a54a6b604cd966fd6e2f2ff547316ef170ce1c1c2ecab7ba7f5e0eb83a66"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7abe36de4f0afe696fc44da5c5960bbf79471513598af743d898a53242a702bc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "003dc0850e69371415e6e4ef1e17c2f0b0c5d896a4d82518b56b23d00ccd0c3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "35a1336f0bcdb1d9d00e158216725932599805d5c16848491944746c6148e44a"
    sha256 cellar: :any_skip_relocation, sonoma:         "9384dfdba9a0b9695b30b0e52a97e2b300c0e93be53645f68ed6d9d1c8f22cac"
    sha256 cellar: :any_skip_relocation, ventura:        "cb1bc46a07edfd40c06193e26d9ed74e7a2147c4b104b1ac40b7640d5c3d4335"
    sha256 cellar: :any_skip_relocation, monterey:       "815a0c8072df470225cb6576e55cff282547f97642d1a62d29148c6daf248dcc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3a01de9943360b6cc41aa27b13264668ee877a13885fbb1f7733c340384b54c"
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
