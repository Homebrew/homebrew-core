class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi/releases/download/v2.70.1/chezmoi-2.70.1.tar.gz"
  sha256 "2def7f49076770934ebc04a62d47fa51b678b2f588ad870fc25a3229fa573e68"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1f94eaf0e2606b3e652f6dbd3df15b9a14eff173cf646ab4386413c5224d8a8f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e35c131bcef5a4c507d2796287ec3150294c23a89f75d0cb45fc4f0aebe5723e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d40f4c15c2d17d1c913bb7018c913f20758a09d887dc48bda55f6838b34ce4cd"
    sha256 cellar: :any_skip_relocation, sonoma:        "1360f636f7d4d261c2f331f4e4c46d258ad22ea47567ee0f6266f83f7eadc0d6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd5fa036d0f5de09c873deb9ab53f4d220a2208457587a59bb6f0459549f3a88"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f5fff25c4265dd24c3c76f0d36bdb840580e0333351565afa2cbd3d4c9aadb1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{File.read("COMMIT")}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    bash_completion.install "completions/chezmoi-completion.bash" => "chezmoi"
    fish_completion.install "completions/chezmoi.fish"
    zsh_completion.install "completions/chezmoi.zsh" => "_chezmoi"
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match(/commit [0-9a-f]{40}/, shell_output("#{bin}/chezmoi --version"))
    assert_match "version v#{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by #{tap.user}", shell_output("#{bin}/chezmoi --version")

    system bin/"chezmoi", "init"
    assert_path_exists testpath/".local/share/chezmoi"
  end
end
