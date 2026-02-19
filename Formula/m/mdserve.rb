class Mdserve < Formula
  desc "Fast markdown preview server with live reload and theme support"
  homepage "https://github.com/jfernandez/mdserve"
  url "https://github.com/jfernandez/mdserve/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "f9ea4605cbc5b3775c1182066ab0a880d10b781fbde128b376a7925401cae926"
  license "MIT"
  head "https://github.com/jfernandez/mdserve.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1a0751c76d08489c44410aaac41b7df82b4ec5a1b684f3768dad4f18acc2b74c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2d4b8bb8971e1cd9069b42ce96a4fc03f90c500b9c3f05f539aa352f62aac402"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05df19e5ebeb29883daa1190ec543a7debecda3194e4bf8982a9e418a21bd6ca"
    sha256 cellar: :any_skip_relocation, sonoma:        "eeee5c41cca8a5d93361eb36208f451a177af46d9c42b093b6e805c27daa3002"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "812790858f3f34942efeae1f6de35dabc0e645e32e5940166211f3dd39bdbf41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7ebc5f297ad4179a2fe54c104ad9cd4d62b5b36fe55c6080516c52e988fd38d"
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
