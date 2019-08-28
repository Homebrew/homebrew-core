class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/v0.2.50.tar.gz"
  sha256 "1fe6ea615f116060c9d4147250a3c5774527e98e3dadc089afdec51a0883163e"

  bottle do
    cellar :any
    sha256 "9c6b6b7082858c13d9d69c1ff81f3915b64328555ac0f1ea1771f1502e77b3ad" => :mojave
    sha256 "426969873ae05661cd002b7ebb24c0519c8cb283d4e97682f27696712819fe9e" => :high_sierra
    sha256 "c955bf6ae91bda956eaf4aca9b6592eaf0ee24cc2e44507e185767eaf6fda94e" => :sierra
  end

  depends_on "rust" => :build
  depends_on "openssl"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://docs.rs/openssl/0.10.19/openssl/#manual
    ENV["OPENSSL_DIR"] = Formula["openssl"].opt_prefix

    system "cargo", "install", "--root", prefix, "--path", "."

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
