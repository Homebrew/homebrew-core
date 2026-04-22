class Ferron < Formula
  desc "Fast, memory-safe web server written in Rust"
  homepage "https://www.ferronweb.org/"
  url "https://github.com/ferronweb/ferron/archive/refs/tags/2.7.0.tar.gz"
  sha256 "cc71d2b54faca70bdeda3ddd5231c6fc22f9eb53b620e83521d9cea0ee65e2ad"
  license "MIT"
  head "https://github.com/ferronweb/ferron.git", branch: "develop-2.x"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5cc8ed23d4151afe9b4d2d8d79b58559ba1f6409ba98840c5516abc3db0d012"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4b873b1aff43e9bbdaea86d2cf83865c7e9b34f34cee1609b7189c80cdcadf7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f90a459669b8525f3057f36389e617013610e6813313f079846d13e3d0047b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "245ab0e748eac7338fddadc3d3b3b8d9f37e6f58fdf7ff538159a7d4a1183c70"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "42c6fa235e3a095d034ba2f4fee43d28f420d08b5352ecf589dfded16043d95e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a206b5b57e12d0ac319d3479e86d7a6ea335ea4640b874e62f9a514da974cd7"
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
