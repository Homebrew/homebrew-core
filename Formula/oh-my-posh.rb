class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.28.1.tar.gz"
  sha256 "326547af3c47810e270d02517d8f29b0b05b1f1ac509d08e23730fa17fa68255"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79198ea74d03c402432c9805a3c85026efd704bb0508005cafd72cb2a11cc2fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c8dba1426629c5544f7282ee017188fc8106a0de004e6c6b6eaf475369254487"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ad987a65ed9a8460ed2f125e9afa67ff763943ce26cd3216a65179a4a2b15ae5"
    sha256 cellar: :any_skip_relocation, ventura:        "b4c915edf12c418303ca0096ecabbf78bd0ffa0dc657196565dc43af9af40fc0"
    sha256 cellar: :any_skip_relocation, monterey:       "ea9c4d2b040a45c45ca4ce1a1f5025dce7212e91d6a7645aebf5017d73c5cc87"
    sha256 cellar: :any_skip_relocation, big_sur:        "6432ad2a99225317840554daefe65b2223c78fdb606480da306af0cbcc0eb7cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "378df1aeb6d94bf9127f0a243d9c817b0f7a9c850dca2f536276ad7d549e9a15"
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
