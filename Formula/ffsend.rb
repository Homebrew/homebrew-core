class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/v0.2.39.tar.gz"
  sha256 "dd4687534c6523fcd1ddab867e75ddb47ce206e210182151f8888901f90c5649"

  bottle do
    cellar :any
    sha256 "ba3f11af9f4da5fd40936eac9a0e7414f70b26db26eb9c5097e0ff8899620679" => :mojave
    sha256 "0beeef4b4dd218bb118cf425647b309263fe4f3fae2a2b91bc3ae259acf4d180" => :high_sierra
    sha256 "0eb73d03fa6e7d25f7afe2e5aa8002c07e34669c626510d8efece4cfc994f822" => :sierra
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
