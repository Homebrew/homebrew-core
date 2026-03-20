class Livereload < Formula
  include Language::Python::Virtualenv

  desc "Local web server in Python"
  homepage "https://github.com/lepture/python-livereload"
  url "https://files.pythonhosted.org/packages/43/6e/f2748665839812a9bbe5c75d3f983edbf3ab05fa5cd2f7c2f36fffdf65bd/livereload-2.7.1.tar.gz"
  sha256 "3d9bf7c05673df06e32bea23b494b8d36ca6d10f7d5c3c8a6989608c09c986a9"
  license "BSD-3-Clause"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "116f5fca359f8496313310d42ec7b1dd307d209c463256f7a951d1d0b56294d3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "651acd218fee0221cf2905deb8fa7a703c24272ffee9696936459741e93214e6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60aa96f61ffc238033fe728ffafaa12a8b66a7c1d96c91fa46894416c59ec2d6"
    sha256 cellar: :any_skip_relocation, sonoma:        "ded998ab1338752e030f905b6806f575a6bb2329741969a837320a582f4c6ca5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c9825e222b28fa8f334b6bbfb90374f1ec5d8b50778fb6641618ad605cffb0dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "31fef9050f7a1e6604ba62e5dc09eaaedae232695864d9e8b7d42543d24a01a3"
  end

  depends_on "python@3.14"

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/f8/f1/3173dfa4a18db4a9b03e5d55325559dab51ee653763bb8745a75af491286/tornado-6.5.5.tar.gz"
    sha256 "192b8f3ea91bd7f1f50c06955416ed76c6b72f96779b962f07f911b91e8d30e9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"index.html").write <<~EOS
      <h1>Hello, world!</h1>
    EOS

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
