class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.31.1",
      revision: "b53467c8cc56e46ef848624193b753c927b89689"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "948c68885b0de2a96aacc8411a45bc1f6c1d8652d7dcd270d0d497c962d66b43"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc0b79aed71f41bd410af6061e387155c36076f91657c0212fbd433b298ef68b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d2d9b770af6f4c323e07e10caf856f280ea8967b73be729fa45d2065f3021957"
    sha256 cellar: :any_skip_relocation, ventura:        "c5fc46dbe2f066a40829ab504684ecfc0598aff118fd14f91229713d4e1753e8"
    sha256 cellar: :any_skip_relocation, monterey:       "23377358ab940177f57630e78fadf28d28e14c24a55bee29e3b3c30fa750eb1e"
    sha256 cellar: :any_skip_relocation, big_sur:        "c491864f12398ee8602c083a3f86b7d20f1373ec8177c4be2188e6675a1cb605"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "408895387f94019773dee74554073d4a6657c67e0764735710ee2f46b0e47d6c"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.date=#{time.iso8601}
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
