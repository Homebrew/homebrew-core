class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v19.18.0.tar.gz"
  sha256 "ce90c38b8ccd93971548f787e85428b626d0fc097971de5b4b99c7fb160aa5cb"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e04abf691c72e5150dce7e313cd53b69acdd3b10c782fd2167fed05f1619fb97"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bf841a49da9e4599708a8bcf21a4e4303aeeaf66792951b48d17a7cd9b3e6aca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b05f624facb7293124f8a20676ddb2ff3e008f8fefecf4a3e0bb7a57578d0c77"
    sha256 cellar: :any_skip_relocation, sonoma:         "eef87b0583f1c981f95c5c689d2379cf1c682f38087601ad5a11415f9fd0a5ed"
    sha256 cellar: :any_skip_relocation, ventura:        "43f7d556169a7faa299833151de9f9858d225c2075083d9bc5e97ec657b6ced8"
    sha256 cellar: :any_skip_relocation, monterey:       "09736c7e1972a0e89440c234750cacba9f45e8ade3432d2f14ed975955cda054"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "86d5654625d5e5945e7f39f47c47fe2ac6709cc313be40b39b05653414589e5f"
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
