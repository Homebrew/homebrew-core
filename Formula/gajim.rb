class Gajim < Formula
  include Language::Python::Virtualenv

  desc "Gajim, an XMPP client"
  homepage "https://gajim.org/"
  url "https://gajim.org/downloads/1.1/gajim-1.1.3.tar.bz2"
  sha256 "261c85444b9cc150f775a5cc5b7dea6031c8fb03f9fe6a9a81cd93d62ee3fd2f"

  depends_on "adwaita-icon-theme"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "glib-networking"
  depends_on "gnupg"
  depends_on "gtk+3"
  depends_on "gupnp"
  depends_on "hicolor-icon-theme"
  depends_on "librsvg"
  depends_on "libsecret"
  depends_on "openjpeg"
  depends_on "pygobject3"
  depends_on "python"

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/fc/f1/8db7daa71f414ddabfa056c4ef792e1461ff655c2ae2928a2b675bfed6b4/asn1crypto-0.24.0.tar.gz"
    sha256 "9d5c20441baf0cb60a4ac34cc447c6c189024b6b4c6cd7877034f4965c464e49"
  end

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/80/f2/f6aca7f1b209bb9a7ef069d68813b091c8c3620642b568dac4eb0e507748/beautifulsoup4-4.7.1.tar.gz"
    sha256 "945065979fb8529dd2f37dbb58f00b661bdbcbebf954f93b32fdf5263ef35348"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/06/b8/d1ea38513c22e8c906275d135818fee16ad8495985956a9b7e2bb21942a1/certifi-2019.3.9.tar.gz"
    sha256 "b26104d6835d1f5e49452a26eb2ff87fe7090b89dfcaee5ea2212697e1e1d7ae"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/93/1a/ab8c62b5838722f29f3daffcc8d4bd61844aa9b5f437341cc890ceee483b/cffi-1.12.3.tar.gz"
    sha256 "041c81822e9f84b1d9c401182e174996f0bae9991f33725d059b771744290774"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/07/ca/bc827c5e55918ad223d59d299fff92f3563476c3b00d0a9157d9c0217449/cryptography-2.6.1.tar.gz"
    sha256 "26c821cbeb683facb966045e2064303029d572a87ee69ca5a1bf54bf55f93ca6"
  end

  resource "cssutils" do
    url "https://files.pythonhosted.org/packages/5c/0b/c5f29d29c037e97043770b5e7c740b6252993e4b57f029b3cd03c78ddfec/cssutils-1.0.2.tar.gz"
    sha256 "a2fcf06467553038e98fea9cfe36af2bf14063eb147a70958cfcaa8f5786acaf"
  end

  resource "entrypoints" do
    url "https://files.pythonhosted.org/packages/b4/ef/063484f1f9ba3081e920ec9972c96664e2edb9fdc3d8669b0e3b8fc0ad7c/entrypoints-0.3.tar.gz"
    sha256 "c70dd71abe5a8c85e55e12c19bd91ccfeec11a6e99044204511f9ed547d48451"
  end

  resource "google" do
    url "https://files.pythonhosted.org/packages/34/4c/9bc51ae2611e5893ff45f8972f20dd7c8408eb5d706a541182ac2da3b0b7/google-2.0.2.tar.gz"
    sha256 "ac0ccd778081f3e373ac5d23253ed11e79a80b11dc1f0ab0ca23833ba7c85de9"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ad/13/eb56951b6f7950cadb579ca166e448ba77f9d24efc03edd7e55fa57d04b7/idna-2.8.tar.gz"
    sha256 "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/69/91/5a9d1769ed7e25083649e87977686423aebed3516112557f4cafd73c9f95/keyring-19.0.2.tar.gz"
    sha256 "1b74595f7439e4581a11d4f9a12790ac34addce64ca389c86272ff465f5e0b90"
  end

  resource "nbxmpp" do
    url "https://files.pythonhosted.org/packages/d6/01/34b2a441926780f26edd21490158afe0eb76beae4efbb6bc4d3323eae69a/nbxmpp-0.6.10.tar.gz"
    sha256 "cd73417777e4847fdd8d0d96c7cafc606952edbd2b9d52a2a72bb2aaa04d08ef"
  end

  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/81/1a/6b2971adc1bca55b9a53ed1efa372acff7e8b9913982a396f3fa046efaf8/Pillow-6.0.0.tar.gz"
    sha256 "809c0a2ce9032cbcd7b5313f71af4bdc5c8c771cb86eb7559afd954cab82ebb5"
  end

  resource "precis-i18n" do
    url "https://files.pythonhosted.org/packages/1f/05/799c3c2c22b9c80f67a8cd4bd772804c6242ab4319974aff2b8d689755f8/precis_i18n-1.0.0.tar.gz"
    sha256 "227ac196b8a31b1209030bfbe90616dd375be946e0a9403349dd45851adf503e"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/02/88/94a9a87fe6cecf1d39eccc9aaa76b48d1f6b7de5a3506ad2cbe7df8bb0ba/protobuf-3.8.0rc1.tar.gz"
    sha256 "3d78230744110a9d842723ca31534bd7a5f47a1507d90f8b1d4b33776ec15cf8"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/46/60/b7e32f6ff481b8a1f6c8f02b0fd9b693d1c92ddd2efb038ec050d99a7245/pyasn1-0.4.5.tar.gz"
    sha256 "da2420fe13a9452d8ae97a0e478adde1dee153b11ba832a95b223a2ba01c10f7"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/68/9e/49196946aee219aead1290e00d1e7fdeab8567783e83e1b9ab5585e6206a/pycparser-2.19.tar.gz"
    sha256 "a988718abfad80b6b157acce7bf130a30876d27603738ac39f140993246b25b3"
  end

  resource "pyobjc" do
    url "https://files.pythonhosted.org/packages/9c/0c/ba59c3da9305e5776ac04cbe69f9a04d51080ce2a3d349194925a0e594b4/pyobjc-5.2.tar.gz"
    sha256 "273ca91aab8a7cec9eae6050a69cfc49e6860137df6507b592fe59754098f51e"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/d3/f5/07579f2986f2eb639932626f69a082598f5e6d4535e1f54a331d9efa97d7/pyobjc-core-5.2.tar.gz"
    sha256 "cd13a2e9be890064a6dd11db7790bbf38502350c532a9a9d05511abb8683b8ea"
  end

  resource "pyobjc-framework-Cocoa" do
    url "https://files.pythonhosted.org/packages/63/fa/a9224a241fffe25f7635235f784d01c5baaed381f534e6c843a07254fd18/pyobjc-framework-Cocoa-5.2.tar.gz"
    sha256 "561785bbc4dd2f05cc836464733382ef6a69cb13338a7bc5f8297f5cd021d0bd"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/40/d0/8efd61531f338a89b4efa48fcf1972d870d2b67a7aea9dcf70783c8464dc/pyOpenSSL-19.0.0.tar.gz"
    sha256 "aeca66338f6de19d1aa46ed634c3b9ae519a64b458f8468aec688e7e3c20f200"
  end

  resource "python-axolotl" do
    url "https://files.pythonhosted.org/packages/79/a5/b324b75d9faeb8eea449dc4dde6f2edb3a4638a0ce8282493186d4af6b09/python-axolotl-0.2.3.tar.gz"
    sha256 "fe0e8147423f8dc4ec1077ea18ca5a54091366d22faa903a772ee6ea88b88daf"
  end

  resource "python-axolotl-curve25519" do
    url "https://files.pythonhosted.org/packages/59/ca/c8111718bcc8da18e9b9868e784293232a58c57159a5ea18f00ee967258f/python-axolotl-curve25519-0.4.1.post2.tar.gz"
    sha256 "0705a66297ebd2f508a60dc94e22881c754301eb81db93963322f6b3bdcb63a3"
  end

  resource "python-gnupg" do
    url "https://files.pythonhosted.org/packages/a7/4e/a7078f08a42b2563169ef20bc74d136015f1f3d0dbfa229070cf8ed4b686/python-gnupg-0.4.4.tar.gz"
    sha256 "45daf020b370bda13a1429c859fcdff0b766c0576844211446f9266cae97fb0e"
  end

  resource "qrcode" do
    url "https://files.pythonhosted.org/packages/19/d5/6c7d4e103d94364d067636417a77a6024219c58cd6e9f428ece9b5061ef9/qrcode-6.1.tar.gz"
    sha256 "505253854f607f2abf4d16092c61d4e9d511a3b4392e60bff957a68592b04369"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/dd/bf/4138e7bfb757de47d1f4b6994648ec67a51efe58fa907c1e11e350cddfca/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/fb/9e/2e236603b058daa6820193d4d95f4dcfbbbd0d3c709bec8c6ef1b1902501/soupsieve-1.9.1.tar.gz"
    sha256 "b20eff5e564529711544066d7dc0f7661df41232ae263619dede5059799cdfca"
  end

  # some popular plugins

  resource "pybonjour" do
    url "https://dev.gajim.org/lovetox/pybonjour-python3/-/archive/e7c010db6372559b9ee9cb64dde75206db684d86/pybonjour-python3-e7c010db6372559b9ee9cb64dde75206db684d86.tar.gz"
    sha256 "fd135e059b0a3ea42d9a4279e8b3fca04508cf13ecf627d9c11b58f2de1233f0"
  end

  resource "plugin_installer" do
    url "https://ftp.gajim.org/plugins_1.1_zip/plugin_installer.zip"
    sha256 "62f3c84060b4cc0f03bbc6b509b6db83831fa6f4ff977640f712a055424c2064"
  end

  resource "omemo" do
    url "https://ftp.gajim.org/plugins_1.1_zip/omemo.zip"
    sha256 "f1ed4690080cd10983135c206b8b5ef62b4aa28dd21a5cf1c294f59d272e2ed6"
  end

  resource "url_image_preview" do
    url "https://ftp.gajim.org/plugins_1.1_zip/url_image_preview.zip"
    sha256 "45a913f799ac6eff435fb738d95d6d2690c4a981704ee7b43c248b3d7b56984e"
  end

  def install
    xy = Language::Python.major_minor_version "python3"
    ENV["SDKROOT"] = MacOS.sdk_path if MacOS.version == :sierra

    venv = virtualenv_create(libexec, "python3")

    (resources.map(&:name).to_set - %w[entrypoints Pillow plugin_installer omemo url_image_preview]).each do |r|
      venv.pip_install resource(r)
    end
    resource("entrypoints").stage do
      # Without removing this file, `pip` will ignore the `setup.py` file and
      # attempt to download the [`flit`](https://github.com/takluyver/flit)
      # build system.
      rm_f "pyproject.toml"
      venv.pip_install Pathname.pwd
    end
    resource("Pillow").stage do
      inreplace "setup.py" do |s|
        sdkprefix = MacOS.sdk_path_if_needed ? MacOS.sdk_path : ""
        s.gsub! "ZLIB_ROOT = None", "ZLIB_ROOT = ('#{sdkprefix}/usr/lib', '#{sdkprefix}/usr/include')"
      end

      venv.pip_install Pathname.pwd
    end

    venv.pip_install_and_link buildpath

    %w[plugin_installer omemo url_image_preview].each do |r|
      resource(r).stage do
        (libexec/"lib/python#{xy}/site-packages/gajim/data/plugins").install Pathname.pwd
      end
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gajim --version")
  end
end
