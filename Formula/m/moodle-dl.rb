class MoodleDl < Formula
  include Language::Python::Virtualenv

  desc "Downloads course content fast from Moodle (e.g., lecture PDFs)"
  homepage "https://github.com/C0D3D3V/Moodle-DL"
  url "https://files.pythonhosted.org/packages/0b/44/9c283a04b0ede0bcaa2f3595b523cb115c662fe349f215631484035126d1/moodle_dl-2.3.13.tar.gz"
  sha256 "7a6d813b3241497fb79a34a428aa266b2d2d3c175e05d46752e0a8040adaddce"
  license "GPL-3.0-or-later"
  revision 9

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a53e87aa65bdc45a4278ea925bfbbce2dde719b28f0e6397895077875b1e5090"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "faa4869bb03e04fe401b35433a82557bfd0db7259a6b2805107dbfce528b2328"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cdf5537298a208262edf1eaba8b69c129cbaf08afcf4b1f6f4de9610765985ef"
    sha256 cellar: :any_skip_relocation, sonoma:        "8171177f3e25568c82f5a41faa9e1250d594a275d258a4dc3032a1ccdc0c99ed"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8d98bd84a96d7949c9ea0ef9dd967e74952a226ffb29b9a429aae62306fb625b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd9bfe1bb856b63a4f50e0655a1ca045ffa854ee4caf4b6deb065b30407dabf7"
  end

  depends_on "cmake" => :build # for pycares
  depends_on "certifi" => :no_linkage
  depends_on "cffi" => :no_linkage
  depends_on "ffmpeg"
  depends_on "python@3.14"

  uses_from_macos "libffi"

  pypi_packages exclude_packages: %w[certifi cffi]

  resource "aiodns" do
    url "https://files.pythonhosted.org/packages/10/da/97235e953109936bfeda62c1f9f1a7c5652d4dc49f2b5911f9ae1043afa9/aiodns-4.0.0.tar.gz"
    sha256 "17be26a936ba788c849ba5fd20e0ba69d8c46e6273e846eb5430eae2630ce5b1"
  end

  resource "aiofiles" do
    url "https://files.pythonhosted.org/packages/41/c3/534eac40372d8ee36ef40df62ec129bee4fdb5ad9706e58a29be53b2c970/aiofiles-25.1.0.tar.gz"
    sha256 "a8d728f0a29de45dc521f18f07297428d56992a742f0cd2701ba86e44d23d5b2"
  end

  resource "aiohappyeyeballs" do
    url "https://files.pythonhosted.org/packages/26/30/f84a107a9c4331c14b2b586036f40965c128aa4fee4dda5d3d51cb14ad54/aiohappyeyeballs-2.6.1.tar.gz"
    sha256 "c3f9d0113123803ccadfdf3f0faa505bc78e6a72d1cc4806cbd719826e943558"
  end

  resource "aiohttp" do
    url "https://files.pythonhosted.org/packages/77/9a/152096d4808df8e4268befa55fba462f440f14beab85e8ad9bf990516918/aiohttp-3.13.5.tar.gz"
    sha256 "9d98cc980ecc96be6eb4c1994ce35d28d8b1f5e5208a23b421187d1209dbb7d1"
  end

  resource "aiosignal" do
    url "https://files.pythonhosted.org/packages/61/62/06741b579156360248d1ec624842ad0edf697050bbaf7c3e46394e106ad1/aiosignal-1.4.0.tar.gz"
    sha256 "f47eecd9468083c2029cc99945502cb7708b082c232f9aca65da147157b251c7"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/9a/8e/82a0fe20a541c03148528be8cac2408564a6c9a0cc7e9171802bc1d26985/attrs-26.1.0.tar.gz"
    sha256 "d03ceb89cb322a8fd706d4fb91940737b6642aa36998fe130a9bc96c985eff32"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/a2/61/f083b5ac52e505dfc1c624eafbf8c7589a0d7f32daa398d2e7590efa5fda/colorlog-6.10.1.tar.gz"
    sha256 "eb4ae5cb65fe7fec7773c2306061a8e63e02efc2c72eba9d27b0fa23c94f1321"
  end

  resource "frozenlist" do
    url "https://files.pythonhosted.org/packages/2d/f5/c831fac6cc817d26fd54c7eaccd04ef7e0288806943f7cc5bbf69f3ac1f0/frozenlist-1.8.0.tar.gz"
    sha256 "3ede829ed8d842f6cd48fc7081d7a41001a56f1f38603f9d49bf3020d59a31ad"
  end

  resource "html2text" do
    url "https://files.pythonhosted.org/packages/f8/27/e158d86ba1e82967cc2f790b0cb02030d4a8bef58e0c79a8590e9678107f/html2text-2025.4.15.tar.gz"
    sha256 "948a645f8f0bc3abe7fd587019a2197a12436cd73d0d4908af95bfc8da337588"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/82/77/7b3966d0b9d1d31a36ddf1746926a11dface89a83409bf1483f0237aa758/idna-3.15.tar.gz"
    sha256 "ca962446ea538f7092a95e057da437618e886f4d349216d2b1e294abfdb65fdc"
  end

  resource "multidict" do
    url "https://files.pythonhosted.org/packages/1a/c2/c2d94cbe6ac1753f3fc980da97b3d930efe1da3af3c9f5125354436c073d/multidict-6.7.1.tar.gz"
    sha256 "ec6652a1bee61c53a3e5776b6049172c53b6aaba34f18c9ad04f82712bac623d"
  end

  resource "propcache" do
    url "https://files.pythonhosted.org/packages/ec/44/c87281c333769159c50594f22610f77398a47ccbfbbf23074e744e86f87c/propcache-0.5.2.tar.gz"
    sha256 "01c4fc7480cd0598bb4b57022df55b9ca296da7fc5a8760bd8451a7e63a7d427"
  end

  resource "pycares" do
    url "https://files.pythonhosted.org/packages/df/a0/9c823651872e6a0face3f0311de2a40c8bbcb9c8dcb15680bd019ac56ac7/pycares-5.0.1.tar.gz"
    sha256 "5a3c249c830432631439815f9a818463416f2a8cbdb1e988e78757de9ae75081"
  end

  resource "readchar" do
    url "https://files.pythonhosted.org/packages/ed/49/a10341024c45bed95d13197ec9ef0f4e2fd10b5ca6e7f8d7684d18082398/readchar-4.2.2.tar.gz"
    sha256 "e3b270fe16fc90c50ac79107700330a133dd4c63d22939f5b03b4f24564d5dd8"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/43/b8/7a707d60fea4c49094e40262cc0e2ca6c768cca21587e34d3f705afec47e/requests-2.34.0.tar.gz"
    sha256 "7d62fe92f50eb82c529b0916bb445afa1531a566fc8f35ffdc64446e771b856a"
  end

  resource "sentry-sdk" do
    url "https://files.pythonhosted.org/packages/65/e0/9bf5e5fc7442b10880f3ec0eff0ef4208b84a099606f343ec4f5445227fb/sentry_sdk-2.59.0.tar.gz"
    sha256 "cd265808ef8bf3f3edf69b527c0a0b2b6b1322762679e55b8987db2e9584aec1"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/94/e7/b2c673351809dca68a0e064b6af791aa332cf192da575fd474ed7d6f16a2/six-1.17.0.tar.gz"
    sha256 "ff70335d468e7eb6ec65b95b99d3a2836546063f63acc5171de367e834932a81"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/53/0c/06f8b233b8fd13b9e5ee11424ef85419ba0d8ba0b3138bf360be2ff56953/urllib3-2.7.0.tar.gz"
    sha256 "231e0ec3b63ceb14667c67be60f2f2c40a518cb38b03af60abc813da26505f4c"
  end

  resource "xmpppy" do
    url "https://files.pythonhosted.org/packages/62/9a/424ef63cdb0af7431495523c396a7deb7db8f17e7a8c18b3f9489f7fccb1/xmpppy-0.7.3.tar.gz"
    sha256 "c0f4ab504cfecf8b127d857b260e480598ae5522cb7b084c84537503646b3bb6"
  end

  resource "yarl" do
    url "https://files.pythonhosted.org/packages/23/6e/beb1beec874a72f23815c1434518bfc4ed2175065173fb138c3705f658d4/yarl-1.23.0.tar.gz"
    sha256 "53b1ea6ca88ebd4420379c330aea57e258408dd0df9af0992e5de2078dc9f5d5"
  end

  resource "yt-dlp" do
    url "https://files.pythonhosted.org/packages/8b/34/7c6b4e3f89cb6416d2cd7ab6dab141a1df97ab0fb22d15816db2c92148c9/yt_dlp-2026.3.17.tar.gz"
    sha256 "ba7aa31d533f1ffccfe70e421596d7ca8ff0bf1398dc6bb658b7d9dec057d2c9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/moodle-dl --version")

    (testpath/"config.json").write <<~JSON
      {
        "token": "invalidtoken",
        "privatetoken": "invalidprivatetoken",
        "moodle_domain": "localhost",
        "moodle_path": "/moodle/"
      }
    JSON

    assert_match "Connection error", shell_output("#{bin}/moodle-dl 2>&1", 1)
    assert_path_exists testpath/"moodle_state.db"
  end
end
