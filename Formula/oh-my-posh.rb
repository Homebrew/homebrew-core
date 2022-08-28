class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.36.0.tar.gz"
  sha256 "9be325955bb721c3aac4f56b233bd0f3c80e5de5b2d839f6f81813096360ffa5"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b883c46eb6edf31f0b3d5d1599553cbb2357db3e0d5d85a44c8ccc59802cd38"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1338617bd2c446e567714fccd4875d25b3297a68de064308547e4245ff801852"
    sha256 cellar: :any_skip_relocation, monterey:       "2b8739bbf65917e4e74101e03c81aaa2aa0777bd887e1cbb8e4170437e8a1079"
    sha256 cellar: :any_skip_relocation, big_sur:        "a2f4c874bc1f6eef2229114ca1397eaf159aceaef61bec8b504e4634e9a02723"
    sha256 cellar: :any_skip_relocation, catalina:       "73b038f282ce5d21de9689572af8518a43a6e4c977eb9ccd5012b2f4d897433b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dad3f852183f70ed63bf54c64d75928a353f9dfabf53a6e267357393fd4c89ed"
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
