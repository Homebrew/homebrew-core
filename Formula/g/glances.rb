class Glances < Formula
  include Language::Python::Virtualenv

  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://files.pythonhosted.org/packages/15/0f/826df6c12110de8bfa9357be60be38bf93230103a9f39fdfa46708ef9200/Glances-3.4.0.3.tar.gz"
  sha256 "e7b1d54180db9961613f5485bf8e2a9fe93d0e58c1bcec0a451b4efe5687c85d"
  license "LGPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22f18a314cf59788d0db48f919f4d96d6af4e12b52da0c09ca86b1ecf0f15087"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1487ddb17c66be835537486f8e94e26cf61abea23fdb5e605386a3998e08157"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d3764224fa08a2838af25daf73994b8d952feadc960d565b5603e2d1378d3ca"
    sha256 cellar: :any_skip_relocation, ventura:        "8b06764f0a662200a9859043254dc7248be133d24bca33fd88654812049cdf48"
    sha256 cellar: :any_skip_relocation, monterey:       "b975b704e59b44f11cc1ade9a0918ca8acf234360e65fb99687fee3f57939cc5"
    sha256 cellar: :any_skip_relocation, big_sur:        "c79bf402bba946aaa7182fb9c822bac9f771ab7af90c03201b0e9b1bf24bd734"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34dca7d55da7760977cc1f4e08cf8fa4dc99233ed07c440ba140c25789503d27"
  end

  depends_on "python-packaging"
  depends_on "python@3.11"

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/d6/0f/96b7309212a926c1448366e9ce69b081ea79d63265bde33f11cc9cfc2c07/psutil-5.9.5.tar.gz"
    sha256 "5410638e4df39c54d957fc51ce03048acd8e6d60abc0f5107af51e5fb566eb3c"
  end

  resource "ujson" do
    url "https://files.pythonhosted.org/packages/43/1a/b0a027144aa5c8f4ea654f4afdd634578b450807bb70b9f8bad00d6f6d3c/ujson-5.7.0.tar.gz"
    sha256 "e788e5d5dcae8f6118ac9b45d0b891a0d55f7ac480eddcb7f07263f2bcf37b23"
  end

  def install
    virtualenv_install_with_resources
    prefix.install libexec/"share"
  end

  test do
    read, write = IO.pipe
    pid = fork do
      exec bin/"glances", "-q", "--export", "csv", "--export-csv-file", "/dev/stdout", out: write
    end
    header = read.gets
    assert_match "timestamp", header
  ensure
    Process.kill("TERM", pid)
  end
end
