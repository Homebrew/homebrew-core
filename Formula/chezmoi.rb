class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.13.1",
      revision: "e2e199bd48b9abb89e9a38fb2a5e42970e9267c4"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a04e2899c10fc154df7d91d8531608caeb99cd2102d83cb8b69690af0b5822ec"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8732adcba7618b00f41fb6403a8441eabec75212239a7ba776538b1aff2d10fb"
    sha256 cellar: :any_skip_relocation, monterey:       "192007cae992cd9f5f057846ff602cbac5aa69d896927d094191fb5d6829bea3"
    sha256 cellar: :any_skip_relocation, big_sur:        "a3ab2d5c29fa15a80b144aa19b2803bffc4e1646b2b57272ed8aca9c2ec6c03d"
    sha256 cellar: :any_skip_relocation, catalina:       "02b7687ac1668c5082e05b9a231a340a22489e510ddbc0f6171aa87f636d10fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbc210768c842bd332569557119b9b569a500d40799a60c39cfb28ae3bd87f73"
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
