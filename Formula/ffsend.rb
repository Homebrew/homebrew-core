class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/v0.2.49.tar.gz"
  sha256 "3f39dd5f8be525904f4486228fcd51c7f3c0263e23eba096d6f6ceb71e6d73f5"

  bottle do
    cellar :any
    sha256 "e6796ea8312afb05e26dd91d395eede8406735861a98897884c5348e1e2cfc65" => :mojave
    sha256 "a92bc2c197a4a497e4c92aa42ac9a1c83eb991d9978bc3f343546d52639d7172" => :high_sierra
    sha256 "53b2fbe5cf406a83fae908ccd1d84586bf766c3a8a93fc3581ae3db52cc7c401" => :sierra
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
    system "#{bin}/ffsend", "help"

    (testpath/"file.txt").write("test")
    url = shell_output("#{bin}/ffsend upload -Iq #{testpath}/file.txt").strip
    output = shell_output("#{bin}/ffsend del -I #{url} 2>&1")
    assert_match "File deleted", output
  end
end
