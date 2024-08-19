class Chezmoi < Formula
  desc "Manage your dotfiles across multiple diverse machines, securely"
  homepage "https://chezmoi.io/"
  url "https://github.com/twpayne/chezmoi/archive/refs/tags/v2.52.1.tar.gz"
  sha256 "622974a9653f07874d9c6a627af130163bf3cde7eb0f1b89baa2f3a7fa76b8a4"
  license "MIT"
  head "https://github.com/twpayne/chezmoi.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released,
  # so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d7a22dce1641d61c5f5858d9b12530f0ec8b809331c68c80e4c648ace09b4a16"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e79ff8b59cf1f1b2d98bece361a5264af78cdfb4607330e4248119259b63b1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e821384245ad5be7f2dc448fbb7b310dfcd56e33f320da8c506abaef543dc248"
    sha256 cellar: :any_skip_relocation, sonoma:         "16e8907c2291412fa08fb3a3bbd0a7285d88545d7e673a797a79568f034f8563"
    sha256 cellar: :any_skip_relocation, ventura:        "da10cf93e099e74688f26f4aafa2754810aae1846dd33baf5ceb2284b15d3c64"
    sha256 cellar: :any_skip_relocation, monterey:       "62d741ac236b99fc313dbc49fcc54637aaccd9d1e964235914ff8a1f9f29db40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34c0520bd51c3fc3a6d5bb9967c20e14646e7e5af3627cc05036c27931ca4069"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
      -X main.builtBy=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    bash_completion.install "completions/chezmoi-completion.bash"
    fish_completion.install "completions/chezmoi.fish"
    zsh_completion.install "completions/chezmoi.zsh" => "_chezmoi"
  end

  test do
    # test version to ensure that version number is embedded in binary
    assert_match "version v#{version}", shell_output("#{bin}/chezmoi --version")
    assert_match "built by #{tap.user}", shell_output("#{bin}/chezmoi --version")

    system bin/"chezmoi", "init"
    assert_predicate testpath/".local/share/chezmoi", :exist?
  end
end
