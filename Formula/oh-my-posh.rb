class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v12.35.0.tar.gz"
  sha256 "049c5c6f004dfdf44868d65e389ee027f1b22ca8287aa3294c64715e48b64f1c"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9bdb5d632fc5ffeff3ecc276def5507e1da76959cd6e9450fcc20a73a84dd8a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7e478f52b4432112fa5aae9ef65c274cdbf4b1ff8da81b628a8b0644bf7b620"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da26dc100cce53c8c43305e94508da30cc21bf55c2fa1555e1a740ae69b1f582"
    sha256 cellar: :any_skip_relocation, ventura:        "837976d8f9fad6aac5cc7fbaf5a2a4bf52791c44556f1c76770623296561b30f"
    sha256 cellar: :any_skip_relocation, monterey:       "9938d9d032669c61cfb789e03b3c06f3f4c843c501be5a804b60180a3e9821f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0508a557e33fd67f2640fec71cddfd1c65f5bc49033e267b4bc5fcfa10d2f63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "db7d97877d17fdec43b71a26ab4e23763e1f4628958128069e5e717b2cf84013"
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
