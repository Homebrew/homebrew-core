class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v23.4.1.tar.gz"
  sha256 "26942cf0f0ca067d59f7654920f1cc4dd64b2d9450d9925792198c183299281c"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "51d8d90e04abd80ff1697d07f6be0cf9d88a66a5b030ae6330bf2107b9be2a3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "af1de2f753571012a5bf04ec308bb10f2f8928f134b76d587cea22309b2969e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd330007a95edb578a1cac4736cf9e796b6276661158100d2884e9560ccf8cc6"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d928be341d962c1857afaa7c35700aa79e00f22660551d5e4e2709508187ad6"
    sha256 cellar: :any_skip_relocation, ventura:        "c99904703a9a3a4d9945d27be385a84b627a88d8bb3017175e5b6574a8d63cd6"
    sha256 cellar: :any_skip_relocation, monterey:       "f7b87f4fb385522a143a94379df447518d1fdb1d85d01d9a7d62888d92f4c30f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0299b64e3ec531014ae26c1b76d003f4855731f67a46e5a2dcf0c79d4ec0406f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Version=#{version}
      -X github.com/jandedobbeleer/oh-my-posh/src/build.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
    assert_match version.to_s, shell_output("#{bin}/oh-my-posh --version")
  end
end
