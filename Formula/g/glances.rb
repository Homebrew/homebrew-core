class Glances < Formula
  include Language::Python::Virtualenv

  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://files.pythonhosted.org/packages/1b/98/1ee2cf6c1c3d84f69ba23d5cd77973d04e8bf7136fe7a44416a408e05ff0/glances-4.1.2.tar.gz"
  sha256 "56d954a20b46fee66257331f96e7107284c8d8e9f0c62d86126969e860378978"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8726158f8d8ff7d410ad3df9d6861c84c6c377fe5b99d58f70135807cf0c6df9"
    sha256 cellar: :any,                 arm64_ventura:  "18b38efc7bf7774bbaa90cfce9b16e306581d4c60d1af6d24e7ed24e512429fa"
    sha256 cellar: :any,                 arm64_monterey: "4ae0ba21d220e5c736ba71b89e0f9aa8529526702bf23031d712e6f3845c7e73"
    sha256 cellar: :any,                 sonoma:         "bf00edf0e41acef73d86fdbc9d0a7f6ae40612b23746a627328b8dd85fce6bab"
    sha256 cellar: :any,                 ventura:        "ebcac258070d06db65423586e5987394b24e259ca0087c65a3e5e0f3a35d240b"
    sha256 cellar: :any,                 monterey:       "0ded472c76f4787f9474f86eb5b8f0cfc9cb3dce40e55237551d18c519042cb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5dba3d46dd1490e851374f9555455c25fd298f158571d0ecf5b00e4dff66138"
  end

  depends_on "rust" => :build # for orjson
  depends_on "python@3.12"

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/70/24/8be1c9f6d21e3c510c441d6cbb6f3a75f2538b42a45f0c17ffb2182882f1/orjson-3.10.6.tar.gz"
    sha256 "e54b63d0a7c6c54a5f5f726bc93a2078111ef060fec4ecbf34c5db800ca3b3a7"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/18/c7/8c6872f7372eb6a6b2e4708b88419fb46b857f7a2e1892966b851cc79fc9/psutil-6.0.0.tar.gz"
    sha256 "8faae4f310b6d969fa26ca0545338b21f73c6b15db7c4a8d934a5482faa818f2"
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
