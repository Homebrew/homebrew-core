class Hwatch < Formula
  desc "Modern alternative to the watch command"
  homepage "https://github.com/blacknon/hwatch"
  url "https://github.com/blacknon/hwatch/archive/refs/tags/0.3.14.tar.gz"
  sha256 "fda2b4fa32a2e78454d1a1169017b9dbcfb9c7cd7bb8210d9af5268b99774328"
  license "MIT"
  head "https://github.com/blacknon/hwatch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "467902e603d0a698291a8b34c6b5beb949b2530c96e4308f128bf90207ccfae6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe6f76daa885cc8bd15b757b5c35788a16912013321c9b8dbbf205c29f668ed0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9293d0e98ffea1edfe58c2085d11b1ec1b903d49e07574f26657504c24929f16"
    sha256 cellar: :any_skip_relocation, sonoma:         "bfda1ab752f3e347957f98bbbcf0f8113bc2cb89c3071268b7e2055be37f06d4"
    sha256 cellar: :any_skip_relocation, ventura:        "1469d631ee1c073dfaf9ff19625dd388361445ce6c938c764c13f45bb2842989"
    sha256 cellar: :any_skip_relocation, monterey:       "6784c364433759e82bf4d41604d618a8cd7742e08c9036a3c9275a1354694556"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90c1b37b55f7704adfad71d1c1d1590505a71bffb33de7fe34eee64605ba490b"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "man/hwatch.1"
    bash_completion.install "completion/bash/hwatch-completion.bash" => "hwatch"
    zsh_completion.install "completion/zsh/_hwatch"
    fish_completion.install "completion/fish/hwatch.fish"
  end

  test do
    begin
      pid = fork do
        system bin/"hwatch", "--interval", "1", "date"
      end
      sleep 2
    ensure
      Process.kill("TERM", pid)
    end

    assert_match "hwatch #{version}", shell_output("#{bin}/hwatch --version")
  end
end
