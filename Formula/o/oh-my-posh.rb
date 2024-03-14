class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v19.17.1.tar.gz"
  sha256 "e8900f9b6e98b2cb9bdfb55488c74f580f004938ae60c2d4e15ba1f412ad1504"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "094cb598586f83dc79890add4707e59d4b382eb1dc5e8cab9840d20881e4a396"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "10d121e58708319b2b04399af569f92155d01bee59aff532d93760d91c8154cd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a6e6609413467cf738ab272e9c2f9b6a8f1160d792a06a75e74625b69ea2261f"
    sha256 cellar: :any_skip_relocation, sonoma:         "c77746eb37b8314f747d71cc133131c5cef1efd86124e479261a707403da6ac7"
    sha256 cellar: :any_skip_relocation, ventura:        "e624f8863000f086ed72f441768cf889271de134f18861d85dbd2b8196f2f054"
    sha256 cellar: :any_skip_relocation, monterey:       "1c13854548a80db472924b8803dce900d3e5ba061abe64f537e27d98aed32c03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2aaef5acf98d41cb6aac311e1ad96d8fbb9c7dc56ac2f1f936c0c7ba1b43381d"
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
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end
