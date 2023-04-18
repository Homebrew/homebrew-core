class Bupstash < Formula
  desc "Easy and efficient encrypted backups"
  homepage "https://bupstash.io"
  url "https://github.com/andrewchambers/bupstash/releases/download/v0.12.0/bupstash-v0.12.0-src+deps.tar.gz"
  sha256 "e3054c03b0d57ba718bd2cab8c24df13153369dea311e5a595d586ad24865793"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a454d4cc3ee169b4a120d858d27b622a4fdd4115029e0d3e1e4eeb4201ee2874"
    sha256 cellar: :any,                 arm64_monterey: "e0c0fb31abb504c253430639b0696097d1fa383d34ebad8b29c072a32159031d"
    sha256 cellar: :any,                 arm64_big_sur:  "723d0b64009392264d64cd0368c6d7ae256eb121a7343776b284a74c87cd9143"
    sha256 cellar: :any,                 ventura:        "32f5b7c2b59eabf50fa186bd5a6f0b8f729d8567bdb19e8e22405aaec55e824d"
    sha256 cellar: :any,                 monterey:       "18d6b61b755aa59d3a6d3c02052a122f746ab8ec8a74af39cd8f6ac000e53f0e"
    sha256 cellar: :any,                 big_sur:        "4715e7d817e328362ebe2ce4cc56eec49a7b9b39d8531b3ca8ba3d21c8626206"
    sha256 cellar: :any,                 catalina:       "b9c6707655d96ef1504957795a9b534ec4913a6919742f53533885762310c430"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45d12691a3dfd70fff9be32cbeffa18233ea789211e1f20142cde85f06777f74"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libsodium"

  resource "man" do
    url "https://github.com/andrewchambers/bupstash/releases/download/v0.12.0/bupstash-v0.12.0-man.tar.gz"
    sha256 "bffe4a9e7c79f03af0255638acfa13fb9f74ed5d6f8987954db1d3164f431629"
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
