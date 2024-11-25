class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v24.9.0.tar.gz"
  sha256 "3b9844ff2558f1ad8eaf5cecf3f451f31b6308f68f91eb4b1b5056ec61e9a583"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "308be3c73c311d3cb1b69c33fb343349ad1459405dea06778444c852173e1362"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f30398332ef5a2f9fc21dea997fc942fc9acaddcaa0c938c9dbdf6b90e84e12b"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1d95d8e679a78ac29faba29715dcb7ae0771b7ebb8d4af5459c51f1eda9f23cb"
    sha256 cellar: :any_skip_relocation, sonoma:        "a8608a893e38a9bf76fdb9aa5ba286c7aaaf0ba368c6b16f19cdf10051c3265e"
    sha256 cellar: :any_skip_relocation, ventura:       "f32d775eeef112f149d0e718f00b2aea60d2edf4e81acf0d049b3151dec0461a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "71ca57afd6fff6c355e5560ad30d1fd27f19baca1679d229faedfc22e66508b1"
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
    assert_match "Oh My Posh", shell_output("#{bin}/oh-my-posh init bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh version")
  end
end
