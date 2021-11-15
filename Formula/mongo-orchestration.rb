class MongoOrchestration < Formula
  include Language::Python::Virtualenv

  desc "REST API to manage MongoDB configurations on a single host"
  homepage "https://github.com/10gen/mongo-orchestration"
  url "https://files.pythonhosted.org/packages/7a/df/245a0f19b54dbd8852b29f53d3448fd89df5283165eb9fe90a83bf59708e/mongo-orchestration-0.7.0.tar.gz"
  sha256 "f297a1fb81d742ab8397257da5b1cf1fd43153afcc2261c66801126b78973982"
  license "Apache-2.0"
  revision 1
  head "https://github.com/10gen/mongo-orchestration.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd965e6c5f77a0d14a7eb917db11b60268677ce338fa303c50f69eda3cd0bab3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3be3d4d3361c13dd72c358ec25226486237b0669b3518dc27094ebb9b5cde0b7"
    sha256 cellar: :any_skip_relocation, monterey:       "0818aea805f4196c41de20ecc0edbb222cd740229c673e7599e8203d6a0cce92"
    sha256 cellar: :any_skip_relocation, big_sur:        "d2042e1ea1f997f23c01dc88bc5e8cecb2fa08c58e5c641035d8d58c2d013be5"
    sha256 cellar: :any_skip_relocation, catalina:       "24d106d1c9511112ce1a7c91664ea001d9d8dd074e303afd71b139fdfca6b14d"
    sha256 cellar: :any_skip_relocation, mojave:         "80b35759af83e1a7effb496027d247cc856363fdad9d34238bf7c58f49b32ff9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02eb4bd1c6fcd120628f289d72e5caf2e3f7efb20611f44cecb0059eb847b7ef"
  end

  depends_on "python@3.10"

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/ea/80/3d2dca1562ffa1929017c74635b4cb3645a352588de89e90d0bb53af3317/bottle-0.12.19.tar.gz"
    sha256 "a9d73ffcbc6a1345ca2d7949638db46349f5b2b77dac65d6494d45c23628da2c"
  end

  resource "CherryPy" do
    url "https://files.pythonhosted.org/packages/56/aa/91005730bdc5c0da8291a2f411aacbc5c3729166c382e2193e33f28044a3/CherryPy-8.9.1.tar.gz"
    sha256 "dfad2f34e929836d016ae79f9e27aff250a8a71df200bf87c3e9b23541e091c5"
  end

  resource "pymongo" do
    url "https://files.pythonhosted.org/packages/72/82/e7196f2f69318dd206db26db68fcfa0ff821d88fbca6d0f0c7b678ba0353/pymongo-3.11.3.tar.gz"
    sha256 "db5098587f58fbf8582d9bda2462762b367207246d3e19623782fb449c3c5fcc"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
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
