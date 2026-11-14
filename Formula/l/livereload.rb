class Livereload < Formula
  include Language::Python::Virtualenv

  desc "Local web server in Python"
  homepage "https://livereload.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/43/6e/f2748665839812a9bbe5c75d3f983edbf3ab05fa5cd2f7c2f36fffdf65bd/livereload-2.7.1.tar.gz"
  sha256 "3d9bf7c05673df06e32bea23b494b8d36ca6d10f7d5c3c8a6989608c09c986a9"
  license "BSD-3-Clause"
  revision 6

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9234e4d26d2c285df2a861d5e6d4b362509bdfe4d2caed78cb2c4edb4dcd6ee2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "330729f945e80e758381fb108c44747799c3b4ed1cb2cc736098659546b9d5a7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "05c47138857c7abeb3d355f6cf57574d3a174a556bf9ffec5e1a6958f5f8474e"
    sha256 cellar: :any,                 arm64_linux:       "bae5fd3b89dcb035a00402cdd98c95785546e1fab10cb8d855492ef74880c881"
    sha256 cellar: :any,                 x86_64_linux:      "3bd41f92bbae130171d0de4664d953904f6cde5323aeea1f6ffaa5095f05e01a"
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
