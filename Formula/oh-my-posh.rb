class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v8.35.0.tar.gz"
  sha256 "a7f5b0f63fe1c54782a946339d3c42f7d6305d6c4f608b7c107697f67134afa9"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c56027e292bcbdb0b75d96ec1f67fcd21871373d4cf856ea00f7e295bf11a72b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93cd41511db0f6fa675304a9a4d59ba67cde9e472ad1fb2b0019e9ff9ad19d72"
    sha256 cellar: :any_skip_relocation, monterey:       "213ce2e47d69fd97067b884112e77237ae7cb80f25b1a897f2b41b5dbf0d2b92"
    sha256 cellar: :any_skip_relocation, big_sur:        "ce1f9769f14f74446e850f2c89c0738f054a82ffc0acdb081251436e09ff0066"
    sha256 cellar: :any_skip_relocation, catalina:       "0434b30188c503e375d8e336dcd33deb2abd97ee407ae9373bfd5f7f65829cb5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06f0a7891ccbc23a8c6ccdfe6bee8ceaf6e4834f0166cbc146c731972d102bb4"
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
