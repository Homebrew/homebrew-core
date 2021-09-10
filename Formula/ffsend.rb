class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/v0.2.73.tar.gz"
  sha256 "76032cfeaf5e8a84592cb501859816f09240c8f6438d1cd96ff63c134cfddc80"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "09c8c0df083f038810ed57e4283e538168743181ef0037b329bf67028422f287"
    sha256 cellar: :any_skip_relocation, big_sur:       "efddc7004af00674fad1af46a8ac9243249215ce612384c82d2e904031168b3b"
    sha256 cellar: :any_skip_relocation, catalina:      "4d42fd442be531f371cf8437da91a80459ea180a2087b2cadb3da6ad493fc327"
    sha256 cellar: :any_skip_relocation, mojave:        "98101171d4fd4990b811e66a08127702f5ed19e086ef03d8e9681bf2892c7c53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ab130640915dced82269f57e30ca6a94e0b55e2d6b3929ee11606086ceea449"
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
