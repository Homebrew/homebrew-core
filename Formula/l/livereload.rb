class Livereload < Formula
  include Language::Python::Virtualenv

  desc "Local web server in Python"
  homepage "https://livereload.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/43/6e/f2748665839812a9bbe5c75d3f983edbf3ab05fa5cd2f7c2f36fffdf65bd/livereload-2.7.1.tar.gz"
  sha256 "3d9bf7c05673df06e32bea23b494b8d36ca6d10f7d5c3c8a6989608c09c986a9"
  license "BSD-3-Clause"
  revision 6

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "c43fed11713b63b6b1623afa3c37966887c350fd407a92a973de08915d1675fd"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "6815a9ba63b9fb99bf14ad6a384136bd52f85bdc7db43e7ab26b4a4049d165aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8aee6a8be384a7968701ef910c17dbcfef2013a3643c9bb5ede9995fb65eb3b0"
    sha256 cellar: :any,                 arm64_linux:       "6dd710d30b2ad23471e2cd9d6cd2a43fe6fd564c96c4592a8b243683cd8e2ccc"
    sha256 cellar: :any,                 x86_64_linux:      "01fd68c88747f1bd1a59285e7f566d66c6d6ca0eaa2fca01347166a0b952422b"
  end

  depends_on "python@3.15"

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/64/2b/8ff2b41620cbba0eeb0862fed21dcaa5a2ad36c6dd9bb465f9ff7a147be2/tornado-6.6.1.tar.gz"
    sha256 "28e6311402af59c8b02e3fa0f5e7d8eb465b25081381803b127d97e6a4395d5a"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"index.html").write <<~HTML
      <h1>Hello, world!</h1>
    HTML

    port = free_port
    pid = spawn bin/"livereload", testpath, "--port=#{port}"

    begin
      sleep 5
      output = shell_output("curl --retry 5 --retry-connrefused -s http://localhost:#{port}/index.html")
      assert_match "<h1>Hello, world!</h1>", output
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
