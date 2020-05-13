class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/v0.2.61.tar.gz"
  sha256 "a4b2bdfa7f18e6306ede64b16961f6659c2673c7bf1161e63e4303c6a72f2a68"

  bottle do
    cellar :any
    sha256 "7c735529d5526478a1077b6cc8a3a516de8a3a3f701ef00159f99a17a30434c9" => :catalina
    sha256 "de48fc060b6a5160359b97ddf7e0a8be4c280c2cfc0ffdecce6fe540b56bc94a" => :mojave
    sha256 "87ed1c7fbfc9d11d8e341d54021dd7241cf00c7606ae1cb049dbf8de8a11ff65" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://docs.rs/openssl/0.10.19/openssl/#manual
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix

    system "cargo", "install", "--locked", "--root", prefix, "--path", "."

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
