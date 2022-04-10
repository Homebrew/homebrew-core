class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.60.0.tar.gz"
  sha256 "addf8d0df67dea1d6cfdb8eb297ccae660739688c9932c12569494eff19a14cc"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb8edc62f70a1941a9e3e472c2573a16161855304e3e50bcd13d7ccc77243dd9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75c2859f1a4ecb22675cebd1b20496c89bf921ad52e2258e3a726fddeb765cce"
    sha256 cellar: :any_skip_relocation, monterey:       "47fd92ddf392fefc0c59dec5576d12b4df78cfb4b13eb5b59c0190f2547dae1a"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a24c6bdf321bfa7c2be1a8dc4a3be6f9325b07662a7517ff65a44b82f403a0b"
    sha256 cellar: :any_skip_relocation, catalina:       "ecaa68c53cbbd91c82fa7124ab4d14e673f4ee6ec4ecc9c3335acaaaf12920f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0993d68863ec14a35d7b5fe639b7618fef651bb8edca38fa5285582146f774e4"
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
