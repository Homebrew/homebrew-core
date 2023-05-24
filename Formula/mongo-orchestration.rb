class MongoOrchestration < Formula
  include Language::Python::Virtualenv

  desc "REST API to manage MongoDB configurations on a single host"
  homepage "https://github.com/10gen/mongo-orchestration"
  url "https://files.pythonhosted.org/packages/80/bc/46ec328dcb9abcc8e9956c02378bfd4bfb053cb94fcf40b62b75f900d147/mongo-orchestration-0.8.0.tar.gz"
  sha256 "9cb17a4f1a19d578a04c34ef51f4d5bc2a1c768f4968948792f330644c9398f6"
  license "Apache-2.0"
  head "https://github.com/10gen/mongo-orchestration.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f16d073e369954fea787793427f7d275f53de6c61cab8b9ff11c543d53a5113d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5aef7d76fdc8fe592d27255770edbbe7d60f3c73d4130cdf3316f1a18042ffa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0970950f69d47605d27b48b7c611647aa08d46a7a77243c4948274f2f612beca"
    sha256 cellar: :any_skip_relocation, ventura:        "6a14d664ce333410d529b828f9506981a4443306b81e3554687c06dfab02981a"
    sha256 cellar: :any_skip_relocation, monterey:       "19da7dd531706ffa6a2209e9b1d456d3bd6e19eed67d7470df8bb67750e3f0ff"
    sha256 cellar: :any_skip_relocation, big_sur:        "48985212df08b1a39281c14db97390b66f37b31c2dd1bb89a832d3051e556aaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5e41489d711b280e40020148693b7ae3dbc4b8e8e049cc06ebeeaec8d532df4"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "bottle" do
    url "https://files.pythonhosted.org/packages/fd/04/1c09ab851a52fe6bc063fd0df758504edede5cc741bd2e807bf434a09215/bottle-0.12.25.tar.gz"
    sha256 "e1a9c94970ae6d710b3fb4526294dfeb86f2cb4a81eff3a4b98dc40fb0e5e021"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "cheroot" do
    url "https://files.pythonhosted.org/packages/08/7c/95c154177b16077de0fec1b821b0d8b3df2b59c5c7b3575a9c1bf52a437e/cheroot-10.0.0.tar.gz"
    sha256 "59c4a1877fef9969b3c3c080caaaf377e2780919437853fc0d32a9df40b311f0"
  end

  resource "dnspython" do
    url "https://files.pythonhosted.org/packages/91/8b/522301c50ca1f78b09c2ca116ffb0fd797eadf6a76085d376c01f9dd3429/dnspython-2.3.0.tar.gz"
    sha256 "224e32b03eb46be70e12ef6d64e0be123a64e621ab4c0822ff6d450d52a540b9"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "jaraco-functools" do
    url "https://files.pythonhosted.org/packages/6d/82/e94ee23a7924ab1c3b617e42ddee24a60add7d988497d5cde8ae524b1525/jaraco.functools-3.6.0.tar.gz"
    sha256 "2e1a3be11abaecee5f5ab8dd589638be8304cc4cb91361fe5e683f4b6d9fb7a3"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/2e/d0/bea165535891bd1dcb5152263603e902c0ec1f4c9a2e152cc4adff6b3a38/more-itertools-9.1.0.tar.gz"
    sha256 "cabaa341ad0389ea83c17a94566a53ae4c9d07349861ecb14dc6d0345cf9ac5d"
  end

  resource "pymongo" do
    url "https://files.pythonhosted.org/packages/9a/31/482f7401e7bbbeb66ab6b4ac263e2b50435f4329cce1e72378972d48f6b5/pymongo-4.3.3.tar.gz"
    sha256 "34e95ffb0a68bffbc3b437f2d1f25fc916fef3df5cdeed0992da5f42fae9b807"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/fb/c0/1abba1a1233b81cf2e36f56e05194f5e8a0cec8c03c244cab56cc9dfb5bd/urllib3-2.0.2.tar.gz"
    sha256 "61717a1095d7e155cdb737ac7bb2f4324a858a1e2e6466f6d03ff630ca68d3cc"
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
