class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.23.0.tar.gz"
  sha256 "27aadcc68cc734d8a72f4424b413a037af042dc4afe806d1755dfa1fb3e1be08"
  license "GPL-3.0-only"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdcab947e577ab2cac69b083ef1a88d1481213349bf3713487699a867eb827e5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c96d782c383e9fed7d65c0d034b3f38a5470f0e946f92fb529c3f318fd4cb0bb"
    sha256 cellar: :any_skip_relocation, monterey:       "4663c0d05691af9e3d2bc13ab44a2c3d835c8936cd6b8d087aeb2af46fb6ad93"
    sha256 cellar: :any_skip_relocation, big_sur:        "93b74e0184270c2cc0dd320d54b93104f5b21202d6e2b0162488b6cfed554f31"
    sha256 cellar: :any_skip_relocation, catalina:       "5566b84d7ce7124c51beb78deab32d3a4387c72648479f0f69334e061f64256f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf4c56f506d801e9cae8bce73b70f89bb5321eefce7be19bc8ddb2c26e2b0acb"
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
    pkgshare.install "themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end
