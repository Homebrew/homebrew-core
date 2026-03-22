class Ferron < Formula
  desc "Fast, memory-safe web server written in Rust"
  homepage "https://www.ferronweb.org/"
  url "https://github.com/ferronweb/ferron/archive/refs/tags/2.6.0.tar.gz"
  sha256 "50e874e4cefa8ac3601b171ffd694c13bef87306ef341b00973de180a3b1355b"
  license "MIT"
  head "https://github.com/ferronweb/ferron.git", branch: "develop-2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "821618486721770d98ab1833670ccf201c80b071dc4cb8cc9eb977db03fbebd1"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45eea19d9191413691d7ba7aa6654aa14c7f478534d04e6c8fcc7471956c6a77"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "128fa9dfb63c4e3550e87ed051dfcdca2eacdb016257b22f85e484fb4a2bbc48"
    sha256 cellar: :any_skip_relocation, sonoma:        "fb599f8a803284e5278193d7a54fa9c4ea8227136dcbc393ed714c09f4a7baf1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f5fcc6194ddca677402c84215d7648f6079c6ffc7a0aa8369a7379c5eb513539"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74810cd4cfb5de5cc214ccc640084ee5b42af88d19bcb224f95f4b028a52e7dd"
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
