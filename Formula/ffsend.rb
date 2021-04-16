class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/v0.2.71.tar.gz"
  sha256 "c9b1fbc5190bcf83a16f01dbbc7a819ce0191ebe371769133177ca2fa5c42d31"
  license "GPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b76c8a582b9c1590b71ab4c75bdeeefd53d82a54a0d3362cc17259e3e402f1c2"
    sha256 cellar: :any_skip_relocation, big_sur:       "3af941741e35f9bc66149c69325cd821205cf7c4095fe9f1a8a721e4efb0fa8a"
    sha256 cellar: :any_skip_relocation, catalina:      "0f84447d4a234f48b1a36fbe72f818c8d2a2737f2433bd5c4532567d88282999"
    sha256 cellar: :any_skip_relocation, mojave:        "1c1f8e0565ae3ccab4eae9318b168547e28f19274e9cc2bd34c4ede84915afb6"
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
