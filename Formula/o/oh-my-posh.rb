class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.0.2.tar.gz"
  sha256 "4e438be57fb2fe4667e05a0235af5913d73f55a99e9491d29f2c694e5bf0b7b5"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "aa3e51489db8879572a24ebd59c34bddc31aa592a403ccf336ef928e2b7430c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e7f731d090e67138c372935f33385ac661987432845939deb2bca7d9b4796d55"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1680ef62b3903da2acec894a89b6a27b46eeef582d0aa365aa806c8148ed0dd6"
    sha256 cellar: :any_skip_relocation, sonoma:        "b50c4f4c0e2a0a5ea6e7ec7834dc2846c8e884972fb036a85c2a2cd5d80d6c8c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2896fc7fc1a56e9e59c60249bb7809ff450c842d4920cd682fd83857351b9c0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c339d20ebe4c75186d4fd73cfd3c9e40e03a24a8e3ee8350db703e928f883f0f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]

    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
    output = shell_output("#{bin}/oh-my-posh init bash")
    assert_match(%r{.cache/oh-my-posh/init\.\d+\.sh}, output)
  end
end
