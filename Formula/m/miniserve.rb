class Miniserve < Formula
  desc "High performance static file server"
  homepage "https://github.com/svenstaro/miniserve"
  url "https://github.com/svenstaro/miniserve/archive/refs/tags/v0.32.0.tar.gz"
  sha256 "30cfabd398f0c17c2eff3fdab115b5681e21fb048f363955a064249d14cd5869"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "47389c1126d93797e519efeadf07ee02e99fec1f3e91fa630fc924b50f97838d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4957a759bdc9818ba2e7685a2a1dd20c1ec41a49b9a6ad774a042ac3af0b86fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d054d066b3e55f3f424b80e6db9ce046eabcbd2e098eb4994a5f61e0e5f1d50"
    sha256 cellar: :any_skip_relocation, sonoma:        "f812a2db501181c9221226c469e13702648bfc64953a43344f0a35fbefca48d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "833b51ec8582ca42e9094f07f1710a081576a7828f8f4b2f52b5acf5b55d6c95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4aabd6fa273c766767936ccfffb2d58a043905bea4950844184fb46eb350a8e3"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"miniserve", "--print-completions")
    (man1/"miniserve.1").write Utils.safe_popen_read(bin/"miniserve", "--print-manpage")
  end

  test do
    port = free_port
    pid = fork do
      exec bin/"miniserve", bin/"miniserve", "-i", "127.0.0.1", "--port", port.to_s
    end

    sleep 2

    begin
      read = (bin/"miniserve").read
      assert_equal read, shell_output("curl localhost:#{port}")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
