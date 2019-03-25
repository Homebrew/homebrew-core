class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/v0.2.42.tar.gz"
  sha256 "674bbc0f23847d3a804a748c9352e9dc6606c3bf1ad466cfd61d8d9bfeebab62"

  bottle do
    cellar :any
    sha256 "3c85a986541735dba16f4f44db9df7e18a73cc7a7ada02bce4300cf024d0e5f6" => :mojave
    sha256 "cbcbf9676b8d5eadfe7e23fde59ad3fcaf3f3c5d458d60f54bab86e17aa4059a" => :high_sierra
    sha256 "f695622fc37a61b1f84f8d99dcc6c92944c6c7d73c5e39ba2d2b1bd68b0474ae" => :sierra
  end

  depends_on "rust" => :build
  depends_on "openssl"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://docs.rs/openssl/0.10.19/openssl/#manual
    ENV["OPENSSL_DIR"] = Formula["openssl"].opt_prefix

    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    system "#{bin}/ffsend"

    (testpath/"file.txt").write("test")
    url = shell_output("#{bin}/ffsend upload -Iq #{testpath}/file.txt").strip
    output = shell_output("#{bin}/ffsend del -I #{url} 2>&1")
    assert_match "File deleted", output
  end
end
