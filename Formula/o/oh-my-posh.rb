class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v19.18.1.tar.gz"
  sha256 "d2e90de759491206b8e3bc84f318629ab3cffeed93b004c5ef57073eb5e2f8f2"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd0c23da706b084d57c70b04a7c123827bacc28e1c932dfe07e4d7b37e3618f9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c643107f0bb04ff4e745664a075fd85cd703a605c8256b9d6815d390f94ca4d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a75b9224065cc2b89efdae8a67647502398426adb00967845c918522241b8f8"
    sha256 cellar: :any_skip_relocation, sonoma:         "32f11d1160517ef4b5154f08bfd2a06a6ea8b15efef0951850cc8256537ed75a"
    sha256 cellar: :any_skip_relocation, ventura:        "ec6aafbe022f6e025c53d061966bd5074c934c6f0adfdd0fd9edfae8f7f14589"
    sha256 cellar: :any_skip_relocation, monterey:       "39e0d1797f625cff52bd99c7bcb83778dfa56a6abcfa141647444c952a2ed7a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d1e3cd346c6ddaa97f5f22a13ba2f05aaabc2ace9bcf3a7af3aaa253f5f0657"
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
