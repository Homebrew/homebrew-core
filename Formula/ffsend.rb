class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/v0.2.52.tar.gz"
  sha256 "b5fd937604eeccd85d7b30d8510784d95497c2412da29c586430275db55043ef"

  bottle do
    cellar :any
    sha256 "91095ea06b9cbe6141ca1eea4868e8afe6ee3e25681c389abaffeabf1d67e52e" => :mojave
    sha256 "a2915c782474c593a9183f0152145c810550798ad9bd679c3b6e317305f89bbf" => :high_sierra
    sha256 "7b86d70e3fb8b555358bbffee6a74acf036302a37387b29de1d314c9dc84b71e" => :sierra
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
