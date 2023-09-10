class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v18.8.1.tar.gz"
  sha256 "00546cf513b87427417aa126a39ddca89e3827d80a4a9c0dc7cc56c13513c3a2"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7fabf728be4d0a8df75b85d808e81e7c4cf02669f1958b5de8c6c11f037895c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "697f356fea412bdda2fb923be4f1f5d0bdf296e711c62e717d5065b7593172e1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "761f009e8da189e1111f63fe42b6ae74f3900306d92a31a38c5d98af6b70ac01"
    sha256 cellar: :any_skip_relocation, ventura:        "bd44211d739398647cb8d7aab6bf9ac6dc583ad9da5e5d6da5dcfeab4af5ee7d"
    sha256 cellar: :any_skip_relocation, monterey:       "c56249a331663d0ffb163a37b1c8e8a963e3fcfee4c4c67f00f1dce1a07b7ac0"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1177d69f96d645564d562d8a23f77600bdb0715e23f7c12f0d490d0355c0d24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f646f81e4ffd9fff6c414d6a0298972acb6df825830b6b88579c85e7ee22c588"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
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
