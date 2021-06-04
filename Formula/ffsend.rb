class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/v0.2.72.tar.gz"
  sha256 "288f988cb0ea77e05571152a7d72f0d2a7e13de86bcaf2ceacb29ea6d51341ef"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cc20b53b713cbfaa71bbe01fcd5a89ab79b2a341e2f3db710b814fac00042be9"
    sha256 cellar: :any_skip_relocation, big_sur:       "42579c13819aa72bff97d81ced32497acdda31b55248b82ad3ddecabe2732607"
    sha256 cellar: :any_skip_relocation, catalina:      "643d1c9363722cc8c07d554b31248cbe1ea21b0694f77fa81315a820a795d17b"
    sha256 cellar: :any_skip_relocation, mojave:        "95470963c1880854a134899af62d1f09c0227a1e0fe93a8436013b35ad5c1fc8"
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
