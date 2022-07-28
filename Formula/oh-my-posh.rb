class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.22.8.tar.gz"
  sha256 "5fa63e9a873751152c1efa431c312ee3583456fa9096df3174c9de1426e6c299"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c81214a930dd001e95c308610219fd7b94a10b00ca18ffaed5ae49a90b2c4087"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6670a1717dcc03d0ad3db23259f7807bc324a0b5628283fa18fbe4525c0c401"
    sha256 cellar: :any_skip_relocation, monterey:       "5a8f5226e815bc2fe72f3bd0521406fd8a4696891c5584deef487ffa33f998db"
    sha256 cellar: :any_skip_relocation, big_sur:        "64dd6a78bd2c1d5d429e2a46632c79773724be085adae56a711ff8d9f073b2f4"
    sha256 cellar: :any_skip_relocation, catalina:       "cceb463d203477106142582ad962ae31b996d904758a3719eb205fb1a7f9ae75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "44da5bcf3a94c67bb0bcc98c96b078a03fed398303c113e872622f265ac85422"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end
