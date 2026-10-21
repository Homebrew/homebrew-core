class Livereload < Formula
  include Language::Python::Virtualenv

  desc "Local web server in Python"
  homepage "https://livereload.readthedocs.io/en/latest/"
  url "https://files.pythonhosted.org/packages/43/6e/f2748665839812a9bbe5c75d3f983edbf3ab05fa5cd2f7c2f36fffdf65bd/livereload-2.7.1.tar.gz"
  sha256 "3d9bf7c05673df06e32bea23b494b8d36ca6d10f7d5c3c8a6989608c09c986a9"
  license "BSD-3-Clause"
  revision 4

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "81261202220ca64ab42119155bf290539a4d1d935894a2bde94818fa1d63731f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "e4c0f649cb9def65438d88b50c24a67c1097cebcd4b89c8773c588c7dcc92f06"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "12eedc4e98202891995b8eda572f50803f4876cca62067ca309a04a73da129f4"
    sha256 cellar: :any,                 arm64_linux:       "5ff267da13e7c4931f2f26052be77c2b87c2ae35c069f7cda861bb81d72d0ea9"
    sha256 cellar: :any,                 x86_64_linux:      "cf4a8e449ad2683f0fa441a49bc2266cac0e2d61bae7a3443a6080f05c50452d"
  end

  depends_on "python@3.15"

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/06/61/53d562a57b28c08eda40b258c0f975e360541943ad7c7bef897a40caafda/tornado-6.5.10.tar.gz"
    sha256 "a6b1ccd08c04b4a06fb5aeb381be99de5ad1e5375c1785e31d78c880feb57687"
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
