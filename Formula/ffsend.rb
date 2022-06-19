class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/v0.2.75.tar.gz"
  sha256 "bcc391a7839f387b5fa72ad4d07e333826e6fe278f1ffe1fa23f5b4ec3dbc033"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15338d4a4bfbcdf84ebd39cee8d0bc46d5585685c3bb3de1474580d1a7d77aa7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "914f11f9535c6d914957e57b945474a7181247cd4d6e41cb5821920e959d878a"
    sha256 cellar: :any_skip_relocation, monterey:       "d54339de7e3f900df00dd5887139672882e5041f2d8f2795f1f58e9b1efc3e4d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4acc10638eaf9e7d0642f88987b035a67ba70949c0a74fbd43a7427d2bde916d"
    sha256 cellar: :any_skip_relocation, catalina:       "c73dd9f2435c47400d0cde77498dda7b4dbe157c602054c166b018f0fb599f7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c145bc5e46c598991c81b692147bdfe7d2e7ab98b704b23e52d433b5d7d1ee2"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", *std_cargo_args

    bash_completion.install "contrib/completions/ffsend.bash"
    fish_completion.install "contrib/completions/ffsend.fish"
    zsh_completion.install "contrib/completions/_ffsend"
  end

  test do
    system "#{bin}/ffsend", "help"

    (testpath/"file.txt").write("test")
    url = shell_output("#{bin}/ffsend upload -Iq #{testpath}/file.txt").strip
    output = shell_output("#{bin}/ffsend del -I #{url} 2>&1")
    assert_match "File deleted", output
  end
end
