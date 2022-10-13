class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.25.0",
      revision: "b3a8879e30a20134c9bef48646055e57aa78d8c5"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47c44d3178641f8676c42d3bc142a123e115fd840e7733fddfc2e100007c3962"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6dfce09695b8b3ccd0df379db58dac7c12c02ae9a73ab0cb7f8a58584b99dc7d"
    sha256 cellar: :any_skip_relocation, monterey:       "7528bf5dae8e3aa3afe6f35805ce02caa8aee94a4d21cb322fc8dca6e12e84c6"
    sha256 cellar: :any_skip_relocation, big_sur:        "7a78e1a8da919c09446486ebde9957f21a84cce92dd9fb67a1271231aad7f85f"
    sha256 cellar: :any_skip_relocation, catalina:       "819b65b9bafa633e933e29f9a35729824f18c55cf45e794ac8ee895e3ee3ba49"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbaaccacaeefdfa78660b94fd168fb8212874cc873738a502759771ed6afcae0"
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
