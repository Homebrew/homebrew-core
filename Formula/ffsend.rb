class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/v0.2.55.tar.gz"
  sha256 "dbcf0891e0ebe3929dbe7e063bd185344d53c9d3ebde6b62d6e82297e85ed8ad"

  bottle do
    cellar :any
    sha256 "800db042519f66b953441db57884564fb207ab0d7018748f94be9b5fe095eb94" => :catalina
    sha256 "41e8b4f1ade60312fbfd67e5f4acb7645c3fd3cb4d156f709126e8bafddc8ce4" => :mojave
    sha256 "3f48c3ec5d482016f70a3993f40bf4e91baddf33330a314de973bfea3c0f18de" => :high_sierra
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
