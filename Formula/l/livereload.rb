class Livereload < Formula
  include Language::Python::Virtualenv

  desc "Local web server in Python"
  homepage "https://livereload.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/43/6e/f2748665839812a9bbe5c75d3f983edbf3ab05fa5cd2f7c2f36fffdf65bd/livereload-2.7.1.tar.gz"
  sha256 "3d9bf7c05673df06e32bea23b494b8d36ca6d10f7d5c3c8a6989608c09c986a9"
  license "BSD-3-Clause"
  revision 3

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "17edcef008f894ff9f27a3f94f23b6d4bef74981bb48379303dfda4cb35a57a2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "ec6c9fd4d7ef5093292693ee0eef02af4fdd7b57266437d53bf72aa301bf6f71"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "9c1e1ca7e1c9ba6c14572b8ec7d1eb251e57649de9812d52a2b9d828726b8aef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:      "fd0afb7bfc39900d5119ea183def872433a59e49d03f709b35fb7e9742ea2faa"
    sha256 cellar: :any,                 arm64_linux:       "b01ff5c68d8b3d2eee54c5f62e564c63c0af62c542e81e9a7e6416ae31632c06"
    sha256 cellar: :any,                 x86_64_linux:      "777f1b568dc8dcd30623e147700b8f2acec750ffe982476435f0c37103de39ea"
  end

  depends_on "python@3.14"

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/10/d3/343e5bb989d6515b1646cf3d40135d73f3d5e45339bded401b56cdac24dd/tornado-6.5.8.tar.gz"
    sha256 "9452e1b208a8bd771e2cb1f2ff564985b9b214bdebbe622793e1799e0a6bd23f"
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
