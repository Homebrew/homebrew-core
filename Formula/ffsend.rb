class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/v0.2.50.tar.gz"
  sha256 "1fe6ea615f116060c9d4147250a3c5774527e98e3dadc089afdec51a0883163e"
  revision 1

  bottle do
    cellar :any
    sha256 "7e278a866e3310a3120de6cdfb5a97f9f6659cf6332554dafb6f087c1c30c4b4" => :mojave
    sha256 "efd32aa29008ea421c9a8de5d6c872d377b689f009188ae7f081c9e9f9762ae3" => :high_sierra
    sha256 "e1b8826b435b1dbddee70dd7f98b6e0dbf16065d38623a6dc5f6383fddcce176" => :sierra
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://docs.rs/openssl/0.10.19/openssl/#manual
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix

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
