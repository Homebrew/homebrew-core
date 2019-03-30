class Gajim < Formula
  include Language::Python::Virtualenv

  desc "Full featured and easy to use XMPP client"
  homepage "https://gajim.org/"
  url "https://gajim.org/downloads/1.1/gajim-1.1.2.tar.bz2"
  sha256 "3283ea5239f67d84874d4efb5b0b0780d1120e5b46c37a5627e5a3121f1ba0d3"

  depends_on "adwaita-icon-theme"
  depends_on "freetype"
  depends_on "gettext"
  depends_on "gtk+3"
  depends_on "jpeg"
  depends_on "librsvg"
  depends_on "pygobject3"
  depends_on "python"

  resource "asn1crypto" do
    url "https://files.pythonhosted.org/packages/source/a/asn1crypto/asn1crypto-0.24.0.tar.gz"
    sha256 "9d5c20441baf0cb60a4ac34cc447c6c189024b6b4c6cd7877034f4965c464e49"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/source/c/certifi/certifi-2018.11.29.tar.gz"
    sha256 "47f9c83ef4c0c621eaef743f133f09fa8a74a9b75f037e8624f83bd1b6626cb7"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/source/c/cffi/cffi-1.11.5.tar.gz"
    sha256 "e90f17980e6ab0f3c2f3730e56d1fe9bcba1891eeea58966e89d352492cc74f4"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/source/c/cryptography/cryptography-2.4.2.tar.gz"
    sha256 "05a6052c6a9f17ff78ba78f8e6eb1d777d25db3b763343a1ae89a7a8670386dd"
  end

  resource "cssutils" do
    url "https://files.pythonhosted.org/packages/source/c/cssutils/cssutils-1.0.2.tar.gz"
    sha256 "a2fcf06467553038e98fea9cfe36af2bf14063eb147a70958cfcaa8f5786acaf"
  end

  resource "entrypoints" do
    url "https://files.pythonhosted.org/packages/source/e/entrypoints/entrypoints-0.2.3.tar.gz"
    sha256 "d2d587dde06f99545fb13a383d2cd336a8ff1f359c5839ce3a64c917d10c029f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/source/i/idna/idna-2.8.tar.gz"
    sha256 "c357b3f628cf53ae2c4c05627ecc484553142ca23264e593d327bcde5e9c3407"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/source/k/keyring/keyring-17.1.1.tar.gz"
    sha256 "8f683fa6c8886da58b28c7d8e3819b1a4bf193741888e33a6e00944b673a22cf"
  end

  resource "nbxmpp" do
    url "https://files.pythonhosted.org/packages/source/n/nbxmpp/nbxmpp-0.6.9.tar.gz"
    sha256 "660d796f6d97b30a5e249417abf012ee30a22b9e40817dde05ca9f35c96cc80d"
  end

  resource "precis-i18n" do
    url "https://files.pythonhosted.org/packages/source/p/precis_i18n/precis_i18n-1.0.0.tar.gz"
    sha256 "227ac196b8a31b1209030bfbe90616dd375be946e0a9403349dd45851adf503e"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/source/p/protobuf/protobuf-3.6.1.tar.gz"
    sha256 "1489b376b0f364bcc6f89519718c057eb191d7ad6f1b395ffd93d1aa45587811"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/source/p/pyasn1/pyasn1-0.4.5.tar.gz"
    sha256 "da2420fe13a9452d8ae97a0e478adde1dee153b11ba832a95b223a2ba01c10f7"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/source/p/pycparser/pycparser-2.19.tar.gz"
    sha256 "a988718abfad80b6b157acce7bf130a30876d27603738ac39f140993246b25b3"
  end

  resource "pyobjc" do
    url "https://files.pythonhosted.org/packages/source/p/pyobjc/pyobjc-5.1.2.tar.gz"
    sha256 "ccfc96382bf04977c68a06733f1d7499a7ddeb1f74760e3f8de483f9a542e691"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/source/p/pyobjc-core/pyobjc-core-5.1.2.tar.gz"
    sha256 "db8836da2401e63d8bdaff7052fdc6113b7527d12d84e58fe075e69ff590e8fd"
  end

  resource "pyobjc-framework-Cocoa" do
    url "https://files.pythonhosted.org/packages/source/p/pyobjc-framework-Cocoa/pyobjc-framework-Cocoa-5.1.2.tar.gz"
    sha256 "a13f451071b7bd00e773874ddf5de4618c121448312d3409dac93a0bcc71962e"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/source/p/pyOpenSSL/pyOpenSSL-18.0.0.tar.gz"
    sha256 "6488f1423b00f73b7ad5167885312bb0ce410d3312eb212393795b53c8caa580"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/source/s/six/six-1.12.0.tar.gz"
    sha256 "d16a0141ec1a18405cd4ce8b4613101da75da0e9a7aec5bdd4fa804d0e0eba73"
  end

  resource "Pillow" do
    url "https://files.pythonhosted.org/packages/source/P/Pillow/Pillow-5.4.1.tar.gz"
    sha256 "5233664eadfa342c639b9b9977190d64ad7aca4edc51a966394d7e08e7f38a9f"
  end

  resource "python-gnupg" do
    url "https://files.pythonhosted.org/packages/source/p/python-gnupg/python-gnupg-0.4.3.tar.gz"
    sha256 "2d158dfc6b54927752b945ebe57e6a0c45da27747fa3b9ae66eccc0d2147ac0d"
  end

  resource "python-axolotl" do
    url "https://files.pythonhosted.org/packages/source/p/python-axolotl/python-axolotl-0.1.42.tar.gz"
    sha256 "ef78c2efabcd4c33741669334bdda04710a3ef0e00b653f00127acff6460a7f0"
  end

  resource "python-axolotl-curve25519" do
    url "https://files.pythonhosted.org/packages/source/p/python-axolotl-curve25519/python-axolotl-curve25519-0.4.1.post2.tar.gz"
    sha256 "0705a66297ebd2f508a60dc94e22881c754301eb81db93963322f6b3bdcb63a3"
  end

  resource "qrcode" do
    url "https://files.pythonhosted.org/packages/source/q/qrcode/qrcode-6.0.tar.gz"
    sha256 "037b0db4c93f44586e37f84c3da3f763874fcac85b2974a69a98e399ac78e1bf"
  end

  resource "pybonjour" do
    url "https://dev.gajim.org/lovetox/pybonjour-python3/-/archive/pybonjour-1.1.2/pybonjour-python3-pybonjour-1.1.2.tar.gz"
    sha256 "50b2459e5410d344e1f8ed2c2d3ab0d81750b008a82477edba5c250c1d592187"
  end

  # some popular plugins

  resource "plugin_installer" do
    url "https://ftp.gajim.org/plugins_1.1_zip/plugin_installer.zip"
    sha256 "62f3c84060b4cc0f03bbc6b509b6db83831fa6f4ff977640f712a055424c2064"
  end

  resource "omemo" do
    url "https://ftp.gajim.org/plugins_1.1_zip/omemo.zip"
    sha256 "4f7bccd0f109ec685722bce6a72eb7f5f12e0cb381c8194af0d504429af7c9f7"
  end

  resource "url_image_preview" do
    url "https://ftp.gajim.org/plugins_1.1_zip/url_image_preview.zip"
    sha256 "45a913f799ac6eff435fb738d95d6d2690c4a981704ee7b43c248b3d7b56984e"
  end

  def install
    venv = virtualenv_create(libexec, "python3")

    resource("Pillow").stage do
      inreplace "setup.py" do |s|
        sdkprefix = MacOS.sdk_path_if_needed ? MacOS.sdk_path : ""
        s.gsub! "openjpeg.h", "probably_not_a_header_called_this_eh.h"
        s.gsub! "ZLIB_ROOT = None", "ZLIB_ROOT = ('#{sdkprefix}/usr/lib', '#{sdkprefix}/usr/include')"
        s.gsub! "JPEG_ROOT = None", "JPEG_ROOT = ('#{Formula["jpeg"].opt_prefix}/lib', '#{Formula["jpeg"].opt_prefix}/include')"
        s.gsub! "FREETYPE_ROOT = None", "FREETYPE_ROOT = ('#{Formula["freetype"].opt_prefix}/lib', '#{Formula["freetype"].opt_prefix}/include')"
      end

      ENV.append "CFLAGS", "-I#{MacOS.sdk_path}/System/Library/Frameworks/Tk.framework/Versions/8.5/Headers" unless MacOS::CLT.installed?
      venv.pip_install Pathname.pwd
    end

    res = resources.map(&:name).to_set - %w[Pillow plugin_installer omemo url_image_preview]

    res.each do |r|
      venv.pip_install resource(r)
    end

    venv.pip_install_and_link buildpath

    xy = Language::Python.major_minor_version "python3"

    ["plugin_installer", "omemo", "url_image_preview"].each do |r|
      resource(r).stage do
        Dir.chdir("..")
        (libexec/"lib/python#{xy}/site-packages/gajim/data/plugins").install r
      end
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gajim --version")
  end
end
