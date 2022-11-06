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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "405127e453e31ede09efe2d9f227f1c3eb73284d83acfdfd6b7e8f933cf98ae5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d23d95a71adb37e14c4e38e026d7e764af41480dd90841d74a7a2422f7f1f0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90a4581f44b9dbdeb3acd2178844740b9c972d9ab482012fd621e0298fd2f2e6"
    sha256 cellar: :any_skip_relocation, ventura:        "2ae530fa702c4b5ab68fe65c83ce5311fc4196685fc406b824c29368c55468ce"
    sha256 cellar: :any_skip_relocation, monterey:       "9cd9b0ad3bfdda51c34bf4ae6fb0a8389b8d0eb2706f0bd08225d5ee8e0c66ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba9a03b8247ec1bdb1beb5dcc3ba9ec4d92950af2e1a15db1eefc9f2b4d802f9"
    sha256 cellar: :any_skip_relocation, catalina:       "6653fea0b774f6007ac75652a1a90c4719c3e913d8b35f3af9e0616baa7fc46c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5b7a67022d7990bbe34724e0ebc0b5ffb3b5f7833f4b89bfb0ffb3614750264c"
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

  service do
    run [opt_bin/"mongo-orchestration", "-b", "127.0.0.1", "-p", "8889", "--no-fork", "start"]
    require_root true
  end

  test do
    system "#{bin}/mongo-orchestration", "-h"
  end
end
