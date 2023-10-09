class Glances < Formula
  include Language::Python::Virtualenv

  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://files.pythonhosted.org/packages/15/0f/826df6c12110de8bfa9357be60be38bf93230103a9f39fdfa46708ef9200/Glances-3.4.0.3.tar.gz"
  sha256 "e7b1d54180db9961613f5485bf8e2a9fe93d0e58c1bcec0a451b4efe5687c85d"
  license "LGPL-3.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f990cb650f3a4a294d7d0f8022755f0aabff3154d19b0539973ea207b455467a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76260a2465b79b559c37a24265456c6a5e7bf6c1d323b0b96486e4f1b4d4d6cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c5d536676c493ff24390d049870c0c7e0537376d342fa4fa7b6a5546da770ca"
    sha256 cellar: :any_skip_relocation, sonoma:         "3a30ca2c4102c5440face5b108ee1dcae9d1f2f5f74528bb5d0e72b31de49362"
    sha256 cellar: :any_skip_relocation, ventura:        "29bfa409dd6bee74012aee885b2f79353439b0828fab15d536042b2414f45fb4"
    sha256 cellar: :any_skip_relocation, monterey:       "ecc476bd72ee7dc845f08b2c278c09a1722826ff00ce96b7d143ab962849ed55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d31446620d0a4d632a8f1fb1da6c43220e81fca2a4b782e5903787782fb6c7d"
  end

  depends_on "python-packaging"
  depends_on "python@3.12"

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/d6/0f/96b7309212a926c1448366e9ce69b081ea79d63265bde33f11cc9cfc2c07/psutil-5.9.5.tar.gz"
    sha256 "5410638e4df39c54d957fc51ce03048acd8e6d60abc0f5107af51e5fb566eb3c"
  end

  resource "ujson" do
    url "https://files.pythonhosted.org/packages/15/16/ff0a051f9a6e122f07630ed1e9cbe0e0b769273e123673f0d2aa17fe3a36/ujson-5.8.0.tar.gz"
    sha256 "78e318def4ade898a461b3d92a79f9441e7e0e4d2ad5419abed4336d702c7425"
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
