class Livereload < Formula
  include Language::Python::Virtualenv

  desc "Local web server in Python"
  homepage "https://livereload.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/43/6e/f2748665839812a9bbe5c75d3f983edbf3ab05fa5cd2f7c2f36fffdf65bd/livereload-2.7.1.tar.gz"
  sha256 "3d9bf7c05673df06e32bea23b494b8d36ca6d10f7d5c3c8a6989608c09c986a9"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cf0acf20fbf0ec3c1840cfd7834817fbbb96a501c01de4c8cc650d3c14679ff4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ccb6ff5538c00d18d803b3cf0e047983ddba8482b70012bcfd380f68d7c7b98c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27d72376258f54e293f6b78b967f8dc4b900a7ba1bd07f5dda30dc1e6c6c6e51"
    sha256 cellar: :any_skip_relocation, sonoma:        "96711fd13739c2b37492806886e0968b56b23c27e73601cda5d51316a85610c6"
    sha256 cellar: :any,                 arm64_linux:   "f4aae309881afbb4eb1cb6e4557fa5cb686fed609870f2407fc390859466236c"
    sha256 cellar: :any,                 x86_64_linux:  "3edf30b01b850978cba1683527fb0d0ce9bbd622403e0dbf2890bdc5137d5a65"
  end

  depends_on "python@3.14"

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/64/24/95ec527ad67b76d59299e5465b3935d05e4294b7e0290a3924b7487df30b/tornado-6.5.7.tar.gz"
    sha256 "66c513a76cda70d53907bc27cf1447557699c2e95aa48ba27a442ff61c3ddfc2"
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
