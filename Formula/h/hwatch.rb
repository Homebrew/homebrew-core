class Hwatch < Formula
  desc "Modern alternative to the watch command"
  homepage "https://github.com/blacknon/hwatch"
  url "https://github.com/blacknon/hwatch/archive/refs/tags/0.3.19.tar.gz"
  sha256 "b0c7da2b8279e483a88019f07a058c978c324f37cd67c34b50de46fb5bd0db16"
  license "MIT"
  head "https://github.com/blacknon/hwatch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b24003504b186e8c333d486d6b537096330efcc8ecf81fead08b461fbcbcaff2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "28288a789480c819fde11788c0b35086e29c19691ce52075565fb46b2abc4f7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78cabd0217cac85bdd8d4b459cf2ff9eac0d5cc6fc865fd1287a2b7cceb07c4d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bd598066ec25a28c99b6af7d3cf2dd4f21568effda47fe2d337eccdb97f6acbd"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae0f06837309e0c232866023b8258b77825353eb931b6f0c8adabf789cb8b7eb"
    sha256 cellar: :any_skip_relocation, ventura:       "c9fa547c1b2b927bde3a9ad76e3a2f730cd3338e1ccff8ad935633900271d7da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e23c602171e0c2b3fef61c8efbaf763609dac8e410368c07798221acd54cd154"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4fd00a8be3bb4833c96b76ca42e5ed029ff3da919deae9a199ed09273840038"
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
