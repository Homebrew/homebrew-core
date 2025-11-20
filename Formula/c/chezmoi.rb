class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi/releases/download/v2.67.0/chezmoi-2.67.0.tar.gz"
  sha256 "2e634ed8b793f6bee75a4976c8f591d35ae8f9c3a5030065302478c39b24d5c7"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45c487c1aff18c53d64db26665daed47cf0f9edcf3bbd060bcd3299a0a811795"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b6df5a319d895cf353eba87bbb1f91ca69d0458e432a3b4e9e9390f167e5b511"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0eb5941d03f3517198f3d485433170299601b4cf30cea8ba17a07fce3dd35730"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef41413402747b0779b480c0efb9304fe6925774238328767b33de9ade718482"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "879102f5bf2c61a0e7ab83af5916cda592f383acec9785876d71d689e7f6a014"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "39d67c93b3b11d9cad8148fca3af69c048ef6e2bc05cc074ef928ac0e46c6b1d"
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
