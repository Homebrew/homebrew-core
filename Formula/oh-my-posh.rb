class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.12.1.tar.gz"
  sha256 "cf378a40dc3a6a2a149cc2ac6176bf6df186974427ad0d570ed158a8689b4a78"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50dc241377e9cf04ff8b975a9e5b9ca3fb69b701607535e6f4daea97d365d074"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c6dea4f6c3207009987a72c2012591617450492006cefe9e493c752452d99ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6abb92593b032f7eaee3fa10f8da9285e04c0456c8ece58725d258b688dc88b0"
    sha256 cellar: :any_skip_relocation, monterey:       "1ca45d9051a1d88ba1ea76c0f6d329c2e7e8a303b8c73ab152dd9a6cdb1c9c63"
    sha256 cellar: :any_skip_relocation, big_sur:        "825885e59ecf60d8b813d8ae16054c7b3a8d2142711b5e2db12df123e0705171"
    sha256 cellar: :any_skip_relocation, catalina:       "e2adf6ef07e1c778129750ac3e04b1c12fd82610736a7d37c00a64183dc42659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "270e83eab64a2a2ccb97d420ab914048bee07cc128004c5703a7d07dd9e56c33"
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
