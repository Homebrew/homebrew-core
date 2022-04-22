class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v7.69.0.tar.gz"
  sha256 "f01b8c7e5b1d20ffdd47a59a0e3d028ae7219b7a601579541a9807bca10bdc84"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc5aa54c371f8602ae7bd1fac20c3d57cdf2efc77e5b7b21a5f0551a84c1bb6b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6600dbf194faff9051ef41983700cc9b249eb9eaff541a7ad82e33b7242b79c8"
    sha256 cellar: :any_skip_relocation, monterey:       "a52d1ae90f194c96f01cdf69cadfd8baff4e53c3d7fb4bf88551065e36e2fde6"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d86e3bd1f9fd186dbda5999e6eadb3f54da14f9149c4adc15664728109186fb"
    sha256 cellar: :any_skip_relocation, catalina:       "f0ad3b90ab4dcd0ad05f4eedc3c69a1d34d6d6e74e052143c9ed752c1ef4f9ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8701ac10609d7a4f9eaf3fedd3b7ae0fdc5f3fd9fa1620fec691d34e7d316006"
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
