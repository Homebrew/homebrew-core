class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v29.9.1.tar.gz"
  sha256 "0c9901c8b674598368c2849abf17af53e87337fcea47c700ba1793773d7c7e39"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "39a2ca71692631c729b27425dfa4f6853ff8fc83798515dd96b07d53bb525cbc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97909ff099711c7824a2e9c2633c4080495c38fa6935727cf73de85a60520e9e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df19cfbfabe7d6753913c830eb7c1f71ad3fe937ab0838c4401e06f79a887c13"
    sha256 cellar: :any_skip_relocation, sonoma:        "d8b37aa06aa8484116928ded09b7380bfd6b0ce985520ef36b24a32856443e20"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fad4ea0af5111f7bdbdc38f98de43020ca69a97d1699fdaa7e49408ce5786362"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5b92739fd93613b85352127f589ac723d06a40350d9ec52fc8c2e67c43b8af90"
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
