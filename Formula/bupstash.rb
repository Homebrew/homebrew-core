class Bupstash < Formula
  desc "Easy and efficient encrypted backups"
  homepage "https://bupstash.io"
  url "https://github.com/andrewchambers/bupstash/releases/download/v0.10.2/bupstash-v0.10.2-src+deps.tar.gz"
  sha256 "eaadac9cd6bc993f0bd143de457054eb6572e093783907478968a80dff1a355c"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "ed18dd9a09063de9d3be7739ab048f977dc89b30d4f17ca6e625dfca7bfd4e6a"
    sha256 cellar: :any,                 big_sur:       "f30a220780b8d94cbbeec8faf0dc13464a38f7029116ee587ea39279c4e3e1cb"
    sha256 cellar: :any,                 catalina:      "0488ba4d72c967d3d2ba923930f248a0bb60122f773f98f4438cfa8b2097084d"
    sha256 cellar: :any,                 mojave:        "b637f71d3cff79b2621c436f597e313cb76d1eef015ed501269b73e0832cc5d2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c4123bcb3b3c06fe08f42913d172f0cf9659b0b414c06e59515fd7a52722769"
  end

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
