class Bupstash < Formula
  desc "Easy and efficient encrypted backups"
  homepage "https://bupstash.io"
  url "https://github.com/andrewchambers/bupstash/releases/download/v0.11.0/bupstash-v0.11.0-src+deps.tar.gz"
  sha256 "b763b71aad87e7ae8e9dec06c5de54796ad3cc6e59859374b9eef066d7f2f941"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "85d6ea7c7ea61a305cd2b977cb317119014476f8dda7266abb69c15537a00672"
    sha256 cellar: :any,                 arm64_big_sur:  "0f9c7184cfb4ee251948a6795419cd35559f59ffa858d1899f431262e74fa57c"
    sha256 cellar: :any,                 monterey:       "c0328dd66273382f9bf95f7b383aa213995304a5ab212cbebb21c4776243bd68"
    sha256 cellar: :any,                 big_sur:        "59c13757da665e6b414cf3bff532149036f01a1f6efc198be4d73953cc08b8ba"
    sha256 cellar: :any,                 catalina:       "e39ef2ac865f91f0bbeaa4149dd5e20372dfa5dabd018ed6bf61b84afced3772"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a52ce9354cda7117afb5dac38a3d75b4b0d0f516eb7a77fdd4b2de172a79f0be"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libsodium"

  resource "man" do
    url "https://github.com/andrewchambers/bupstash/releases/download/v0.11.0/bupstash-v0.11.0-man.tar.gz"
    sha256 "74645f4a243f786261123667e1849085cc2eda095bf3ebbb792cb0195adeeae9"
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
