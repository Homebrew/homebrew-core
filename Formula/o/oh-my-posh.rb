class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/refs/tags/v19.18.0.tar.gz"
  sha256 "ce90c38b8ccd93971548f787e85428b626d0fc097971de5b4b99c7fb160aa5cb"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ca82c6e0c9b07a709689353ff0de4fff1b8f4a7c832dbc96345971d5d5570234"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "05b84dc7282540b177a1e2e219bb57d82d3ffb99519c7c6b09b84cd692dae47d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7350bd7f443372988deafcbc23e2a683c72f95b1d62d73380ff3a2dc2e556c39"
    sha256 cellar: :any_skip_relocation, sonoma:         "65ddd34b8de718675a3d6b52615dfe73204eb9066c830971331264a30c78eb9a"
    sha256 cellar: :any_skip_relocation, ventura:        "c76744d356451955143dbe36973460b203f7e8edb9e0c4e3582f618723663865"
    sha256 cellar: :any_skip_relocation, monterey:       "15aad22eeaa76f870892438e693fe4d2b9b04a2d49b9031ed78495ec5bb3f049"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a94f929d6626fcdaa477023d39a4b7e7a4f27940b645371ba76ec96ab2c6ac6"
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
