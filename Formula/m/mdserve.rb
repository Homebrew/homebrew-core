class Mdserve < Formula
  desc "Fast markdown preview server with live reload and theme support"
  homepage "https://github.com/jfernandez/mdserve"
  url "https://github.com/jfernandez/mdserve/archive/refs/tags/v0.5.1.tar.gz"
  sha256 "2ed28cd3618179d500b20de83fef230562494995b63a6d36102a9a56f04dafd6"
  license "MIT"
  head "https://github.com/jfernandez/mdserve.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8a4a31050fbf8105505b95fda4e1abc572188a817362ffda788d1e95ddfa4ceb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2118b20f945546bd3640360116a974476d9e49eff2119d8f3b7aeb3f451328bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fbae1902dd9fa910320c11b6e2add1fd167e2e096a9e1581c4a5ce92c962a05"
    sha256 cellar: :any_skip_relocation, sonoma:        "db777786d3c41e43e13bd5e09e2e2ff45d60968ba93b50c39358498058fbc394"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98344963b674824941f58fb5aab7dd766eabf705c60a4cfffa62cf5206fa65b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "43fb09aa8474058bc4960af12298c0ac7927056d58515b18724ef148e39273b8"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mdserve --version")

    (testpath/"test.md").write("# Test\n\nThis is a test markdown file.")

    port = free_port
    pid = spawn bin/"mdserve", "--port", port.to_s, "test.md"

    sleep 1

    begin
      output = shell_output("curl -s http://localhost:#{port}")
      assert_match "This is a test markdown file", output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
