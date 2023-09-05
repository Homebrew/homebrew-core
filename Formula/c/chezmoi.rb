class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi.git",
      tag:      "v2.39.0",
      revision: "153ff486c16ac654298225a15d8131201fe7c154"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7507ff6798267a894e1cfafc3c194fd36a741254a550127068590bacc2c5e36c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f41bdf000336f43a2e020837b1184beecc597659a665f8557425381042d20ebb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a036d779b3c1750abedeed7a0ecfc4acf377d702fd4614727a00f6494eae1bc"
    sha256 cellar: :any_skip_relocation, ventura:        "c9dc2e104ffdbecb76c6c8dcbc02590bd3f0f82dc779e953eb010e3d3a9a67d0"
    sha256 cellar: :any_skip_relocation, monterey:       "0ce213336a9a99b1a24a1573c8d2a5960e51ebf41436199c12c3c3166a66dec1"
    sha256 cellar: :any_skip_relocation, big_sur:        "9621748d8a9c4cf8fbec6721894e15514517191c55e778b2aa7c17fa88ee0c10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4df65f4d11f6ff0a13c67b522f77a2eaf7caed6fa00de6e9929ac5c86c9b7064"
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
