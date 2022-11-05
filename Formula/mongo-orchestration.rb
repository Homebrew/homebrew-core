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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d8b5f326ab50ba43eb1a0f87bae36b742dea4ec2ed06c7f9f47add2f132d2469"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "49f821511197094a5a40cb754106e46e25e552b728c57ecdbdcaf715ac4c731b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e1a5c2e60195773fa8de9314eb6716d1895f3e1734eceffe4f09871ce358eed0"
    sha256 cellar: :any_skip_relocation, monterey:       "0ef330a503399b8e0dca2b5fe4fcdc066ae7bcac46d366432351af5347b8808e"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ef7e709e3891baf8ab9e394f5affc91504453b04e533b93cc225d78a32f59de"
    sha256 cellar: :any_skip_relocation, catalina:       "ac92880c25d8d0e565ca602489024907fc8d1877a324560c6d2fc00ad5b0a0a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "940f5d76181acd2920977d77ceee856e5da30b7df3ab413f4c4e3898e35cfb8b"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/7c/58/75f3765b0a3f86ef0b6e0b23d0503920936752ca6e0fc27efce7403b01bd/bottle-0.12.23.tar.gz"
    sha256 "683de3aa399fb26e87b274dbcf70b1a651385d459131716387abdc3792e04167"
  end

  resource "CherryPy" do
    url "https://files.pythonhosted.org/packages/56/aa/91005730bdc5c0da8291a2f411aacbc5c3729166c382e2193e33f28044a3/CherryPy-8.9.1.tar.gz"
    sha256 "dfad2f34e929836d016ae79f9e27aff250a8a71df200bf87c3e9b23541e091c5"
  end

  resource "pymongo" do
    url "https://files.pythonhosted.org/packages/ec/ff/9b08f29b57384e1f55080d15a12ba4908d93d46cd7fe83c5c562fdcd3400/pymongo-3.13.0.tar.gz"
    sha256 "e22d6cf5802cd09b674c307cc9e03870b8c37c503ebec3d25b86f2ce8c535dc7"
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
