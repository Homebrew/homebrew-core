class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/v0.2.57.tar.gz"
  sha256 "fcf789cdd8d5abb746834e695aa323220b8c284f3f9cce3ceefc48167a63ac5f"

  bottle do
    cellar :any
    sha256 "0b90ceb3197e202bfd133c263c364ed66f984e21d1e87c162eb0f3fd7047d687" => :catalina
    sha256 "90683c978990aa9c1f1096cb299db258f7fcdc6ce3f33c536de6ca2a8d1dcdf6" => :mojave
    sha256 "d89c379a5b5bd49cb57bd4d3c5e5fa4ad5e0d4e970dfbb3b0ea556a1e21a9219" => :high_sierra
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
