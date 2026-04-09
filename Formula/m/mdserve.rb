class Mdserve < Formula
  desc "Fast markdown preview server with live reload and theme support"
  homepage "https://github.com/jfernandez/mdserve"
  url "https://github.com/jfernandez/mdserve/archive/refs/tags/v1.1.0.tar.gz"
  sha256 "a13490d0b63af960cb74507e2cd684b4ecc0f59325e1946f04e82595e2641aa8"
  license "MIT"
  head "https://github.com/jfernandez/mdserve.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "14ef5c7e6cd6c0fb3f941824f84ac34c3c8124d5f5bf9c78e89b16f96d4ca324"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "231269e5e95a19282c8372311bf248469f265f8bbccb4a55ea79ee5a5f4890f1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e9196915dcbbc08997a3983ae3c0dbe227c1e7a4dfb24acc8d92de3225b4a0c"
    sha256 cellar: :any_skip_relocation, sonoma:        "3e48efc973366def35b6be6a76e1436f8fac4de92ebb00745119e982edc2d6e5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ac98a80cd18a7f550c030b932703c3983953c6c174804909376e6c0d21640f47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "482b075537a6af00bf3856510cf13127987c1b7ee29722bc5f3c65207e106ebd"
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
