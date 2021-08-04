class Bupstash < Formula
  desc "Easy and efficient encrypted backups"
  homepage "https://bupstash.io"
  url "https://github.com/andrewchambers/bupstash/releases/download/v0.10.2/bupstash-v0.10.2-src+deps.tar.gz"
  sha256 "eaadac9cd6bc993f0bd143de457054eb6572e093783907478968a80dff1a355c"
  license "MIT"

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libsodium"

  resource "man" do
    url "https://github.com/andrewchambers/bupstash/releases/download/v0.10.2/bupstash-v0.10.2-man.tar.gz"
    sha256 "50720383e4154add1e948a59a9c75b90bef7a8848f38aadcaebaecd38181b732"
  end

  def install
    system "cargo", "install", *std_cargo_args

    resource("man").stage do
      man1.install Dir["*.1"]
      man7.install Dir["*.7"]
    end
  end

  test do
    (testpath/"testfile").write("This is a test")

    system bin/"bupstash", "init", "-r", testpath/"foo"
    system bin/"bupstash", "new-key", "-o", testpath/"key"
    system bin/"bupstash", "put", "-k", testpath/"key", "-r", testpath/"foo", testpath/"testfile"

    assert_equal (testpath/"testfile").read,
      shell_output("#{bin}/bupstash get -k #{testpath}/key -r #{testpath}/foo id=*")
  end
end
