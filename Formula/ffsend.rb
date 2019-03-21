class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/v0.2.30.tar.gz"
  sha256 "53130e6b50c6b14c8ec04d6d4077800a0b1855ffd0b2bdbb475ae8ec208695bd"

  bottle do
    cellar :any
    sha256 "547a7c5fabd3111ee422c993127dfa281b25b2866ed6fbf82edd3fde478c90b8" => :mojave
    sha256 "60070578e9f9a187767b172bc1de242405063641b0cb2092a539f7f02709e85d" => :high_sierra
    sha256 "4abb91e3d0ab8e03a1b54e116414601cc98503a881cdc790a23508b17ad10064" => :sierra
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
