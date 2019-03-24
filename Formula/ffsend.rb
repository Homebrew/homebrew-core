class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/v0.2.39.tar.gz"
  sha256 "dd4687534c6523fcd1ddab867e75ddb47ce206e210182151f8888901f90c5649"

  bottle do
    cellar :any
    sha256 "ee9ba954a7cc1d1ed485f089b4d7ddbee77577b21b84224a2409835294747c14" => :mojave
    sha256 "63cb63e3afe1895ea7875319d753cea605e7e19fa6465cecdd63aa618d4c749f" => :high_sierra
    sha256 "03ac9baf6505ac3364e8be2c00d072ab7d33b6487d03523c893b7bdc4adfd86e" => :sierra
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
