class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/v0.2.52.tar.gz"
  sha256 "b5fd937604eeccd85d7b30d8510784d95497c2412da29c586430275db55043ef"

  bottle do
    cellar :any
    sha256 "2648c957876a524b24c21517412a527f4db5d49b83920bd478cbc102ae86c99c" => :catalina
    sha256 "1de65c841a42d009553325db5b44da81f627d93305aef023306acd88a0589b09" => :mojave
    sha256 "88573bde2de8745093c57d7fa13c0bd148210b2a607210bee0bf281a9527c625" => :high_sierra
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
