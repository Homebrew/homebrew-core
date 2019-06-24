class Ffsend < Formula
  desc "Fully featured Firefox Send client"
  homepage "https://gitlab.com/timvisee/ffsend"
  url "https://github.com/timvisee/ffsend/archive/v0.2.48.tar.gz"
  sha256 "ef4615a466a0a8cf63aa4744bae20e8e15b0e392d022a89bd42c21a7cb63bf0f"

  bottle do
    cellar :any
    sha256 "29385daffc58b00d7589d71de173d32931a65cf5967756dd2168bafa873623b3" => :mojave
    sha256 "5061bcd5bdf65402d36ed490eeba87dbfad593555320501ac450f854431b34a1" => :high_sierra
    sha256 "868467a2c04209fdfd723f4be93c1120a478eb4743b2f5e2af17e3111df39485" => :sierra
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
    system "#{bin}/ffsend help"

    (testpath/"file.txt").write("test")
    url = shell_output("#{bin}/ffsend upload -Iq #{testpath}/file.txt").strip
    output = shell_output("#{bin}/ffsend del -I #{url} 2>&1")
    assert_match "File deleted", output
  end
end
