class Livereload < Formula
  include Language::Python::Virtualenv

  desc "Local web server in Python"
  homepage "https://github.com/lepture/python-livereload"
  url "https://files.pythonhosted.org/packages/43/6e/f2748665839812a9bbe5c75d3f983edbf3ab05fa5cd2f7c2f36fffdf65bd/livereload-2.7.1.tar.gz"
  sha256 "3d9bf7c05673df06e32bea23b494b8d36ca6d10f7d5c3c8a6989608c09c986a9"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0fed352cb705f7468ec7349e98c01df7979143b3fd5d2eed8ee051e4705f6d36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fba0ef1c9980a6d84962fe1fcb16e76b8f02978814b5788dea5f575e3a8397ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "55b277ba3ca4ecd34efbdf16d668d4a0d74e5209f87cf725c0ab6f08eea98949"
    sha256 cellar: :any_skip_relocation, sonoma:        "cfddf49c8779a00ad2f1e31c643e0a91b6f779973b0cdb2c1a8d4e92f951723a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6f08550650309b022ca110f1466bce5e8fccc2d9516bd03c914c94f3e4bcb75"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4d6031b88eed3220e42fc8258f15e0185bedcd6b214bcededc6584c30164bff4"
  end

  depends_on "python@3.14"

  resource "tornado" do
    url "https://files.pythonhosted.org/packages/37/1d/0a336abf618272d53f62ebe274f712e213f5a03c0b2339575430b8362ef2/tornado-6.5.4.tar.gz"
    sha256 "a22fa9047405d03260b483980635f0b041989d8bcc9a313f8fe18b411d84b1d7"
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
