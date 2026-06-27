class Ferron < Formula
  desc "Fast, memory-safe web server written in Rust"
  homepage "https://www.ferronweb.org/"
  url "https://github.com/ferronweb/ferron/archive/refs/tags/2.8.1.tar.gz"
  sha256 "32354ffed4fbe8caede924d420e6a7ac84127f264c47e1e738b462d9479c0680"
  license "MIT"
  head "https://github.com/ferronweb/ferron.git", branch: "develop-2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d42a7e5867ed39bf7161dd6c0632c35746738bff3a40933473a5efe12494505"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "acf6389a55ef19ab32492a85640018a4c6a50cfd96f593a243fb8a174ce68a77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7121834cabb58791d821073d34d133f2ae79c7a3373fe9ae603da713f766478b"
    sha256 cellar: :any_skip_relocation, sonoma:        "15403c255fd2ece0b5a0c27c0a76e0a5a88c679ef6c239b5963259d1fa67c430"
    sha256 cellar: :any,                 arm64_linux:   "7ff6796b6bc6acff4aebe2210667b3abd4d2f65857d6b2c0137b10cd23c2269e"
    sha256 cellar: :any,                 x86_64_linux:  "970385f090fd99d31d23adf799432205ef6a2c9365ce3f91b67498467f2036f5"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "ferron")
  end

  test do
    port = free_port

    (testpath/"ferron.yaml").write "global: {\"port\":#{port}}"
    begin
      pid = spawn bin/"ferron", "-c", testpath/"ferron.yaml"
      sleep 3
      assert_match "The requested resource wasn't found", shell_output("curl -s 127.0.0.1:#{port}")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
