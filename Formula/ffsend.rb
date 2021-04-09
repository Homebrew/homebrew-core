class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/v0.2.71.tar.gz"
  sha256 "c9b1fbc5190bcf83a16f01dbbc7a819ce0191ebe371769133177ca2fa5c42d31"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2e9aafcb0d0f8d814380e66ba0683b1d6c01cb8d43dc11b31a1f910cf2bcb485"
    sha256 cellar: :any_skip_relocation, big_sur:       "2a7a8b305ba7565092063295174c02b94dd84fd5b7c2c0f200237a70bec234f7"
    sha256 cellar: :any_skip_relocation, catalina:      "a17eeed601899a63bcbad6527af1cb5abf76f3589d2d72a04c2347092e62451e"
    sha256 cellar: :any_skip_relocation, mojave:        "2ffef18d2670ee9ddb27dc8d488781e07c110115834b18c4c416a72dc3a01a6c"
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
