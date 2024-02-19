class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v19.11.3.tar.gz"
  sha256 "5db3024baed3d6473e0a9344fe6680dc4943815ae54b802e7940903a9ee367a1"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9624ea0b05c42921f879346669cba49a4d08d89c6128d31b70ac84fd6feffc77"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f2002582931f4c110551e58145b493c11a7a95b01ad55d74f43f0adec948e98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ada5241a70eee8f44778891bb4a9305faefd467dedcf76b4f00064881ca22f66"
    sha256 cellar: :any_skip_relocation, sonoma:         "895cd8075540022299c3da4c0dacfaf540b72211604d7c79c2dc7ab0eee27e01"
    sha256 cellar: :any_skip_relocation, ventura:        "82a37b748e254eca65fa1148778283b5b885674e655824c7db184ce326ba11da"
    sha256 cellar: :any_skip_relocation, monterey:       "8936e99fb7f3930e7da6cbe8ca5e6da6be7c056b0dc249394b6b743400547346"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6d842ced0864a7a7fd9134efd7297c11cf3fae49182337fcabf2c0891e4b257"
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
