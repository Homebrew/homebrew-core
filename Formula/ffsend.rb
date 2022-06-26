class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/v0.2.76.tar.gz"
  sha256 "7d91fc411b7363fd8842890c5ed25d6cc4481f76cd48dcac154cd6e99f8c4d7b"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4a33d7dd1465a0ee60e67f351d9d33a8f343fb0f478bbb951e1ad4f013704b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d330f6673e5c524439241a00ab78d2a9904ae98bc809bd7884d2410b01ec1bf5"
    sha256 cellar: :any_skip_relocation, monterey:       "bc7917b4fcf38c237f70fae69642bacfa9bb5c0907160a8a20615838d5f24c62"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ac4ab065ea9b47203cf9c320c890d1a3014621111ce532fa3a58bba4d58eb2d"
    sha256 cellar: :any_skip_relocation, catalina:       "6a6216d395863c342f3a1babc7896238a41b57e3712a9aeb1483d343e4314ee8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8df5439e73182be4487788bf4c3c576c840f2a5bae1b360a5a21945fa54172fb"
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
