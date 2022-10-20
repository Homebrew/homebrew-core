class MongoOrchestration < Formula
  include Language::Python::Virtualenv

  desc "REST API to manage MongoDB configurations on a single host"
  homepage "https://github.com/10gen/mongo-orchestration"
  url "https://files.pythonhosted.org/packages/7a/df/245a0f19b54dbd8852b29f53d3448fd89df5283165eb9fe90a83bf59708e/mongo-orchestration-0.7.0.tar.gz"
  sha256 "f297a1fb81d742ab8397257da5b1cf1fd43153afcc2261c66801126b78973982"
  license "Apache-2.0"
  revision 2
  head "https://github.com/10gen/mongo-orchestration.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49f821511197094a5a40cb754106e46e25e552b728c57ecdbdcaf715ac4c731b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1a5c2e60195773fa8de9314eb6716d1895f3e1734eceffe4f09871ce358eed0"
    sha256 cellar: :any_skip_relocation, monterey:       "0ef330a503399b8e0dca2b5fe4fcdc066ae7bcac46d366432351af5347b8808e"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ef7e709e3891baf8ab9e394f5affc91504453b04e533b93cc225d78a32f59de"
    sha256 cellar: :any_skip_relocation, catalina:       "ac92880c25d8d0e565ca602489024907fc8d1877a324560c6d2fc00ad5b0a0a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "940f5d76181acd2920977d77ceee856e5da30b7df3ab413f4c4e3898e35cfb8b"
  end

  depends_on "python@3.10"

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/95/e3/5749d7657b6fb38d65afb3c0b345514a783de7a9feb4fab594fa0bacc2a0/bottle-0.12.21.tar.gz"
    sha256 "787c61b6cc02b9c229bf2663011fac53dd8fc197f7f8ad2eeede29d888d7887e"
  end

  resource "CherryPy" do
    url "https://files.pythonhosted.org/packages/56/aa/91005730bdc5c0da8291a2f411aacbc5c3729166c382e2193e33f28044a3/CherryPy-8.9.1.tar.gz"
    sha256 "dfad2f34e929836d016ae79f9e27aff250a8a71df200bf87c3e9b23541e091c5"
  end

  resource "pymongo" do
    url "https://files.pythonhosted.org/packages/97/79/9382c00183979e6cedfb82d7c8d9667a121c19bb2ed66334da930b6f4ef2/pymongo-3.12.3.tar.gz"
    sha256 "0a89cadc0062a5e53664dde043f6c097172b8c1c5f0094490095282ff9995a5f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/71/39/171f1c67cd00715f190ba0b100d606d440a28c93c7714febeca8b79af85e/six-1.16.0.tar.gz"
    sha256 "1e61c37477a1626458e36f7b1d82aa5c9b094fa4802892072e49de9c60c4c926"
  end

  def install
    virtualenv_install_with_resources
  end

  plist_options startup: true
  service do
    run [opt_bin/"mongo-orchestration", "-b", "127.0.0.1", "-p", "8889", "--no-fork", "start"]
  end

  test do
    system "#{bin}/mongo-orchestration", "-h"
  end
end
