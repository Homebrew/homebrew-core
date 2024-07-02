class Glances < Formula
  include Language::Python::Virtualenv

  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://files.pythonhosted.org/packages/cf/30/ee8448b3152e04b2546a01e94f3ef007b06339150931470bace4cb801db8/glances-4.1.0.tar.gz"
  sha256 "45489fa807bcffd52a29595029d7829126817ca30ac251b1b7733ac10867ab23"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "8a01f4b473db4f13bd35d8c81f7a1964788d2f282d6483e2e6520b5026c6f8f0"
    sha256 cellar: :any,                 arm64_ventura:  "51af708864dec28c459dba90ff75292fc711bc9186261a940b311e71bc504255"
    sha256 cellar: :any,                 arm64_monterey: "1fe3392293ad3d721d732269ad8ebf2309250b548dcd7a542bf469139c8da978"
    sha256 cellar: :any,                 sonoma:         "d01098e938a261bdd88e41659ea09c9dcd29d8fbe4325f30dcc25f425940b9cd"
    sha256 cellar: :any,                 ventura:        "a72e89bd88e0219059fc082fd9528aba54c1a5e612eec41eba6537ae45131cc0"
    sha256 cellar: :any,                 monterey:       "480cb774a76d9c01046fd7640545ab47d40456ed0a5d86fd113253839295c10f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2ec7c59706e873c0662c97d2ac0fee76ba7f1ff191f9a69cdbf9863a528c480d"
  end

  depends_on "rust" => :build # for orjson
  depends_on "python@3.12"

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "orjson" do
    url "https://files.pythonhosted.org/packages/f9/ba/a506ace6d9e4cb96cb4bed678fddc2605b8befe7fbbbecc309af1364b7c4/orjson-3.10.5.tar.gz"
    sha256 "7a5baef8a4284405d96c90c7c62b755e9ef1ada84c2406c24a9ebec86b89f46d"
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
