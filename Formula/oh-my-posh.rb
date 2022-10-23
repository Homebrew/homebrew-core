class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.6.7.tar.gz"
  sha256 "69de8d9f47b67ae7994f852ce93a3d76edd9242537868709f8ebc0593fdbb1b7"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c1ba24374152ca1d50c4f3d30cbd2f96655b34148a869555ba1fc46e7ba25ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32867d89a953f8042ee4d445ff2300ddcca842aa6f3f8d0018c6e7eaab001223"
    sha256 cellar: :any_skip_relocation, monterey:       "3b3253168115500e40540c1468d117bcfae6c1e2278cc3582b6c542996179759"
    sha256 cellar: :any_skip_relocation, big_sur:        "2b99c6292ce9795f415ac2d420612a2c8b57cb4b03238f0e03a4f497f00bdcf8"
    sha256 cellar: :any_skip_relocation, catalina:       "4a1fe7a2dde797efe54b3a2573519c7125a164fb6e0a5b6132f8e2526eb4fe20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5c84e97c717bb416e0dc0935466d849d987d9a80afe37e2e7219fddf6cd0d35"
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
