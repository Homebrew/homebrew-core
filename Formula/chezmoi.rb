class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.11.2",
      revision: "13de45fdd4d2eddd3447d80c129754090fde80ac"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e0b5680980b085eede8f2e822e5177ba8869c4fd8a58f30f4a2dc010c38f00b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dcd1eca0457aed10cba964272515eb4f55dd380de743f702cf57a11d8c89e53c"
    sha256 cellar: :any_skip_relocation, monterey:       "f79375eae32a92653e5b61605b78cee3d3840129fcad0b55bd43b71d510ace55"
    sha256 cellar: :any_skip_relocation, big_sur:        "193ee179e5cb8706c9d8066d89f13aae1623a095a62c32c65781768e2891c314"
    sha256 cellar: :any_skip_relocation, catalina:       "ce88c01c64bec9d9219a99d1c1717f5566c502f5e913dc20a11e13c4761eee19"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9066de43eb931405e0742dabc12ea488b8b228a8e8372ce6808b36a82dcce65e"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.rfc3339}
      -X main.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bash_completion.install "completions/chezmoi-completion.bash"
    fish_completion.install "completions/chezmoi.fish"
    zsh_completion.install "completions/chezmoi.zsh" => "_chezmoi"

    prefix.install_metafiles
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match "version v#{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by #{tap.user}", shell_output("#{bin}/chezmoi --version")

    system "#{bin}/chezmoi", "init"
    assert_predicate testpath/".local/share/chezmoi", :exist?
  end
end
