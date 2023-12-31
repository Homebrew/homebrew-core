class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v19.3.0.tar.gz"
  sha256 "b7aa286403d458ed41a66d7ddac4392d0eff85f2620c4def3b43c39fbd02355a"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "05515d44d13ce6964e25c1ba09498d49a0ef23a3e4e60c767a326f2a548c2695"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c2c7a93114334134c72de9040641a10c5bcbe9e288e87ad5bc9116420d44869"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e900792c5b3691f399d87be0874eba3b63d2fadda1e0569474e83bcf38c8119"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ba38c03042f16f67d5767f931732f45e3eaa07cfd6760a92d6d1936bb7a1433"
    sha256 cellar: :any_skip_relocation, ventura:        "33dce8a2275c41c0e55afcecf7db682b753520e4b9ece3b47356bac92f9f653a"
    sha256 cellar: :any_skip_relocation, monterey:       "40fddc67d55969dd3eefc9ccf63b37af24540401a0e6c6d761fae48ead972974"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19e6e464cb489798fc3a806d5ab6ec30070a6df322fd56c5eb6159bd30e7477c"
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
