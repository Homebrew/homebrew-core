class Glances < Formula
  include Language::Python::Virtualenv

  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://files.pythonhosted.org/packages/15/0f/826df6c12110de8bfa9357be60be38bf93230103a9f39fdfa46708ef9200/Glances-3.4.0.3.tar.gz"
  sha256 "e7b1d54180db9961613f5485bf8e2a9fe93d0e58c1bcec0a451b4efe5687c85d"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f17c0c9e81be37b201a3f0159d5d1a6195a69ab530948745479bce34b80bca86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8526dc0031dbbb534295d8fbb5c1918b39f9b2314d258680bed06113899ad5f1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e37ea6c56d3eedcf110f4b63309b2aad64cca791c9fcb35df8feae872adcfc8"
    sha256 cellar: :any_skip_relocation, ventura:        "7c60330a40a54fb30dc029d5fc6286e25770a4e53421612f4bc8cd49297f316a"
    sha256 cellar: :any_skip_relocation, monterey:       "3a0dcca91cefeffb46fa9e88d8e26d14fb9f0562790623457d5f1a5d0d148ac2"
    sha256 cellar: :any_skip_relocation, big_sur:        "597134ccf0d1e33547a8e355cb3c1ea9070bd1fc747d3e64b74cef07a41db71e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f2edd50ee5eacfb976ebb1edee95b8e40ee2cc633d20598737510ffa72142eb"
  end

  depends_on "python@3.11"

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
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
