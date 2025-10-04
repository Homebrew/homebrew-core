class Mdserve < Formula
  desc "Fast markdown preview server with live reload and theme support"
  homepage "https://github.com/jfernandez/mdserve"
  url "https://github.com/jfernandez/mdserve/archive/refs/tags/v0.4.1.tar.gz"
  sha256 "12f5e32606d18475ad6ed69cd714d89d3e4e97ada63e6f7137f4fe6e2b996244"
  license "MIT"
  head "https://github.com/jfernandez/mdserve.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "813f2d73f1a0c24e2317a6fbe5fd234d5d36e747ecf285b1feed51722a9867d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "70eea9b3f0e132c5e74c00d5024fd7daaaf6ffdc1c19b221926e3097a9b4180a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f373a3798c34d54583b894bba53f936a52bf863b09c8062aa42d767bc4aea581"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba559ce37810604df1694d1861ca7440574e541e900c04d33ab2b5011fa52255"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3f76f37a35593aff70c056a15d2778d519ed41adcfc5be37bf52c7e1a8cc5ccb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "524b9a4ef36471f35661c76caff7b676b7861bd800d374dda15ea18cce588d78"
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
