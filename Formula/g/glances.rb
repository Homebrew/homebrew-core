class Glances < Formula
  include Language::Python::Virtualenv

  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://files.pythonhosted.org/packages/1f/48/d8bfb3c29f6da15aa217f60e2cf77712f927ede3928fd6d60e3b60e53b39/glances-4.2.0.tar.gz"
  sha256 "a39771b8900bd9e825c5257ddf255e6b02ccc44af2a44988c5cf210f0e66cf92"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a6e5b31d670a63340bf6cf216534787aa7d24fa0339a99ae0d2c3420168c5c27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "54f970b996962263bb8c1305c79d42abaf4fbbcd553b39d3fde62f297ac9cc81"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "25f1969be8b8b38897686047cd48e086705f327cf3e18a5800d9aa20fa553be1"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5c1c970a95df29f812577cce62528226fe10fa95a97abb09823f42058684a37"
    sha256 cellar: :any_skip_relocation, ventura:       "80d94cc189cab7a1dc32824fe3ee9eed1d169abc8dc7b397000a4d60e497693f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a7adeb85a5740ee362ae68949d5423230ad59033bfb3d443ca1a1bc67d30095f"
  end

  depends_on "rust" => :build # for orjson
  depends_on "python@3.13"

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/26/10/2a30b13c61e7cf937f4adf90710776b7918ed0a9c434e2c38224732af310/psutil-6.1.0.tar.gz"
    sha256 "353815f59a7f64cdaca1c0307ee13558a0512f6db064e92fe833784f08539c7a"
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
