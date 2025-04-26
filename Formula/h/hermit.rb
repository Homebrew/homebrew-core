class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://github.com/cashapp/hermit/archive/refs/tags/v0.44.7.tar.gz"
  sha256 "0a3f4051a0b09bdf6b15931a21c6d7e97f3a31c8aa6febc74e22110b42dba531"
  license "Apache-2.0"
  head "https://github.com/cashapp/hermit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7585bf4e233ca42eb7eb153c73e85f7aa66be9c4a070a6d39c146d241616db2f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bba224cfce77b545c3811cb8de066998f6f55634e85971e9c2a5f8273761d0ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ccb5ab366fa353af568c24e90db94da59d8ecbcc3ecc24195d3c57c3f38101a"
    sha256 cellar: :any_skip_relocation, sonoma:        "52cc8d080611b09f8f682c4b07e0a0f43f29ea0ecb925ffc4b72e4c54b6d4907"
    sha256 cellar: :any_skip_relocation, ventura:       "6414458f5a8944bdde33fca594f85a65035e97d9aa102980670547c5606ccda6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ea347a4fa4c9256a1a817d4ccac17794e29542a1d5df810b424f495be333dd4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f69ee783d9f238eb9ded37a06693bcdad925899b3b36a2340e05c4baa969c60"
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
