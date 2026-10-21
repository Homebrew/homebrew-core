class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi/releases/download/v2.73.3/chezmoi-2.73.3.tar.gz"
  sha256 "0c09db0e696857093d0d68c5f33adaafae63496e0b23fcbb1dd7edc4d2e2f3b1"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "f9745598a7971392888a4a9ad2c5b753c6a64db0bd4588799319aded257a68d0"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0093c29e40bc4b3d402889cf1e9520bcfedebcfe53db662a8ade4c9b042e1414"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f79755697eea52390dc379b162d5eb0a2aedb92127f572ea9f189dc1d0851904"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "fc54865df1ed5ddebd911035a20369710d4c77cc9522c25e993dc50434936d8e"
    sha256 cellar: :any,                 x86_64_linux:      "a37b2e28e0370e1f40036ee75d020e26a4067426f19bc425f4533bb44a556c0c"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser)

    bash_completion.install "completions/chezmoi-completion.bash" => "chezmoi"
    fish_completion.install "completions/chezmoi.fish"
    zsh_completion.install "completions/chezmoi.zsh" => "_chezmoi"
  end

  test do
    # test version to ensure that version number is embedded in binary
    output = shell_output("#{bin}/chezmoi --version")
    assert_match "version v#{version}", output
    assert_match "built by #{tap.user}", output

    system bin/"chezmoi", "init"
    assert_path_exists testpath/".local/share/chezmoi"
  end
end
