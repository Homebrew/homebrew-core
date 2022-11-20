class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.16.1.tar.gz"
  sha256 "1ebefaa314578a925e98bfb4e88500ec957aaf6ec242c9148aedcaa4d220d492"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4266ca9476c31f8c4703147038816bd94363ee3204ea4fe3601e9b89d4ef59d6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8091f4f08086b424bef7b77874c39c4a831c40ecad885acd0d99a11ef5132a30"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2514b4f8e4d453bf9028239d303673b1d6283eac301e1c56ddf1d44d083b629d"
    sha256 cellar: :any_skip_relocation, ventura:        "664996cb81afdc1efa143d19145f1e59abf18ffe10a63a3b005cd8cb20364080"
    sha256 cellar: :any_skip_relocation, monterey:       "e62469ac12931d02504bf6baa7530c769c16537c25bc2ebf73557b6118a67cd7"
    sha256 cellar: :any_skip_relocation, big_sur:        "77f165cb1ac7065150acad4f623ef8d0d924c6e44afdef240b902b4e57670126"
    sha256 cellar: :any_skip_relocation, catalina:       "afd21f172d7e98f9d5047048cd2970a12964e25f4a7a311f1317d01b7b976097"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fbc63822c2fa8d926115edf66208b83a95dc9e56fb806e0ba216caae76ea3e26"
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
