class Bupstash < Formula
  desc "Easy and efficient encrypted backups"
  homepage "https://bupstash.io"
  url "https://github.com/andrewchambers/bupstash/releases/download/v0.11.1/bupstash-v0.11.1-src+deps.tar.gz"
  sha256 "9433379491e7552032620789a0f8a702159a0744484e3fd9fe73eb9eb1d71351"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a0f4b5a3553ba1ff2e170935ec847274764eade20975ff6d5508caf2074eaea6"
    sha256 cellar: :any,                 arm64_big_sur:  "4e91d7e3036edfa4b3d63f338156a0521ace45c9d3cec2cd1570abad97c78262"
    sha256 cellar: :any,                 monterey:       "3a25f52779809a6d650798fed2d885acd471170f05ed01fab141e81c34148b00"
    sha256 cellar: :any,                 big_sur:        "92274d26804ddc2e662f63e10613f33679096660d82d6e2ae2719cedadbd97b7"
    sha256 cellar: :any,                 catalina:       "a5f39fd07b3d55bb3e9366528ea2a24d5f09b5ee44c23038d43a08419eec47a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "369b767438a7ca9284a12ae5dd5c7103ace313b1034d00dc1cf82fcecd3e333b"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libsodium"

  resource "man" do
    url "https://github.com/andrewchambers/bupstash/releases/download/v0.11.1/bupstash-v0.11.1-man.tar.gz"
    sha256 "abbf79420e15e2619deb379d966e0b118ad67fcd411e52b1e642d8ba80b730bf"
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
