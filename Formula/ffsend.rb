class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/v0.2.50.tar.gz"
  sha256 "1fe6ea615f116060c9d4147250a3c5774527e98e3dadc089afdec51a0883163e"

  bottle do
    cellar :any
    sha256 "cf6ae121b94b7f763f99673ee10500db66eb39bba0ca981a16cd4b80884f52d9" => :mojave
    sha256 "ec0150c21cac10d09741bf35302909566d3b3a5c303d90ab5d05811c25333da3" => :high_sierra
    sha256 "18399268fdd5c49619e641037b398eef3a3e14211f44af86e784d729e2d68a09" => :sierra
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
