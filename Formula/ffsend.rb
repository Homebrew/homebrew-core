class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/v0.2.50.tar.gz"
  sha256 "1fe6ea615f116060c9d4147250a3c5774527e98e3dadc089afdec51a0883163e"

  bottle do
    cellar :any
    rebuild 1
    sha256 "6cf0ae6d9625a786bb5d9e3c3e6ee37d825c4c7b9261abdc37c16b94c582bf57" => :mojave
    sha256 "e128bf0040e6f9e69e139c6d24378b3a7bff87188d73214b8ccfd185462d51be" => :high_sierra
    sha256 "461cbca1722730dbb8ff1401bdf98f354a67162788e1fd6c948c2630d5b3cc53" => :sierra
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
