class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v19.11.2.tar.gz"
  sha256 "b0626e15687e67d5bfbab77353774e28588542b94b7c715940ee365c5746434c"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "75ea97dc019ef6acfb71878e7e5ba724bede7cfb5321f5c53d9ff87469dc245c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c470e604c0f5b80e10c161778950a04989335d1b058293fb110dc4dedd5989c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "13d7d0e3bc33ebd04d6ace3f30e5f94d5f80d1ce2e598d80e68150f63917a154"
    sha256 cellar: :any_skip_relocation, sonoma:         "f936951b43e68ea409ddd547e7b24e5308f0af4fc44cbbd19f0a06a14219ee1d"
    sha256 cellar: :any_skip_relocation, ventura:        "3f06515ea79c469f923cff2765e92368523e3dd86171485aaba3b1be008028bc"
    sha256 cellar: :any_skip_relocation, monterey:       "2c5a0386a042f2ed7981dbfcb5cde343b103e938f45d7003a4fa489d3c52b645"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3ba1e58a043436df82c6a2e6823de0fae6812c1a9820ee4e9d358f3d513a555"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end
