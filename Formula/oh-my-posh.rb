class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v10.2.0.tar.gz"
  sha256 "8d4a5afd016c47b91bcd3097f3e5c84107644cd57b4ec6055d5059bec075587c"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65ca2cb88c230a97de5cd0d83adcdc8b0a7a4ce36e9046775732876181511a73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "202d00e75522b09185778cbde6a2465753a5a34c058d55ff1120b98eb8101952"
    sha256 cellar: :any_skip_relocation, monterey:       "fc8b2f3a77b6759381f01e1ce62d27100208726f91b9c0e576b1605567a4421e"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ae39ba72fe2e64556ff0c8577dc839c0439b698b34561d4e2bf0f729f8617c4"
    sha256 cellar: :any_skip_relocation, catalina:       "b4dae64409973e1ba8ec2fc843ad96b64a27bcc0614cd52c0ebcfc6f2c1dd066"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fdbffd8237e38df85237547cb6e9c7dcae4f14d370563ba7b10205caf02bbf1"
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
