class Glances < Formula
  include Language::Python::Virtualenv

  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://files.pythonhosted.org/packages/7c/80/8eefe7e32a3aae422ed06c88c1689cdd31301c0d8ac33db913525496d1be/glances-4.0.8.tar.gz"
  sha256 "5caaf44f252d693fc9fc1e921285a207b911c62f5997d804c38541d143ee474f"
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
    url "https://files.pythonhosted.org/packages/f8/16/c10c42b69beeebe8bd136ee28b76762837479462787be57f11e0ab5d6f5d/orjson-3.10.3.tar.gz"
    sha256 "2b166507acae7ba2f7c315dcf185a9111ad5e992ac81f2d507aac39193c2c818"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/ee/b5/b43a27ac7472e1818c4bafd44430e69605baefe1f34440593e0332ec8b4d/packaging-24.0.tar.gz"
    sha256 "eb82c5e3e56209074766e6885bb04b8c38a0c015d0a30036ebe7ece34c9989e9"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/90/c7/6dc0a455d111f68ee43f27793971cf03fe29b6ef972042549db29eec39a2/psutil-5.9.8.tar.gz"
    sha256 "6be126e3225486dff286a8fb9a06246a5253f4c7c53b475ea5f5ac934e64194c"
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
