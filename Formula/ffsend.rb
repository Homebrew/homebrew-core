class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/v0.2.59.tar.gz"
  sha256 "4eb33136ee4d0daaf5aeb6eba410181ddeed946cce6942796083e7218d520070"

  bottle do
    cellar :any
    sha256 "b30219c0350fab468f5e240889dabda09ef7920bac7d41a75fc9c7efb49dbc19" => :catalina
    sha256 "910fe50ce65a6150ef953a1ff9e8fca8cad0bfc77efbf8f0991397d374d1dfca" => :mojave
    sha256 "e4ac10d824640ddef3a173e5c89943b3838b4f49a2d23d1d6e2d01bdb2724f86" => :high_sierra
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
