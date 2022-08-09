class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.29.2.tar.gz"
  sha256 "e1257951ce9edcbd300e068f43eb7dfcea424fd7f787239544708de5b18c3cfa"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12658056b9044d1fb9d7f4726a5304489e0f6b92df72875f77fccfd2bd033403"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4042d959625541ec5f88a7a4b1bf37465415aad85c08a6a118f5ae42327e4161"
    sha256 cellar: :any_skip_relocation, monterey:       "d2f6c0492ceca5c9b2209866fb8f18abfe970829ce8952f2fd79e181166a2a88"
    sha256 cellar: :any_skip_relocation, big_sur:        "6776a30d8a3e721467395583bc567ce470fac6ccc9b972def6d2efbe0ccac944"
    sha256 cellar: :any_skip_relocation, catalina:       "8f3556a1e11ec2b51c262cd2439d98a8811b24b661ae6b173a9ad31afbf39a75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4cb0ed8b062e5015165da6c0e768c840b9b939b20bcb5525dbdcfbe560237377"
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
