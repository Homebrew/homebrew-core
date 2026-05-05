class Meshtastic < Formula
  include Language::Python::Virtualenv

  desc "Python API & client shell for talking to Meshtastic devices"
  homepage "https://meshtastic.org"
  url "https://files.pythonhosted.org/packages/68/0b/1eae93ceba68c63c8246f475748241d3bbf8e05af4e680a3a04b2a3ed20c/meshtastic-2.7.8.tar.gz"
  sha256 "98292e43884e239429056b8a0b31291e169a0b7ededae2c7caa737a8cc9f1a97"
  license "GPL-3.0-only"

  depends_on "rust" => :build
  depends_on "libyaml"
  depends_on "python@3.14"

  on_macos do
    depends_on "llvm" => :build if DevelopmentTools.clang_build_version <= 1699
  end

  fails_with :clang do
    build 1699
    cause "pyobjc-core uses `-fdisable-block-signature-string`"
  end

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/38/61/0b9ae6399dd4a58d8c1b1dc5a27d6f2808023d0b5dd3104bb99f45a33ff6/argcomplete-3.6.3.tar.gz"
    sha256 "62e8ed4fd6a45864acc8235409461b72c9a28ee785a2011cc5eb78318786c89c"
  end

  resource "bleak" do
    url "https://files.pythonhosted.org/packages/16/df/05a3f80ca8e3f7f5b0dba68a9e618147c909ccdba1468f07487dc8d72a9d/bleak-3.0.2.tar.gz"
    sha256 "c2229cb8238d5876b4bd05c74bf7a1aea1f88da39d2e51ac9dfd5cc319d5265f"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/25/ee/6caf7a40c36a1220410afe15a1cc64993a1f864871f698c0f93acb72842a/certifi-2026.4.22.tar.gz"
    sha256 "8d455352a37b71bf76a79caa83a3d6c25afee4a385d632127b6afb3963f1c580"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/e7/a1/67fe25fac3c7642725500a3f6cfe5821ad557c3abb11c9d20d12c7008d3e/charset_normalizer-3.4.7.tar.gz"
    sha256 "ae89db9e5f98a11a4bf50407d4363e7b09b31e55bc117b4f7d80aab97ba009e5"
  end

  resource "dbus-fast" do
    url "https://files.pythonhosted.org/packages/5f/cd/402b0e524bdf37d8b1d22b1d926c538bf1d2eedf115ea1d401c6c08a7d81/dbus_fast-4.0.4.tar.gz"
    sha256 "43137f0b73a7adbf7d5c0e9eb9d8d34df9e6e0aeafade2166e641c52dfe0a853"
  end

  resource "dotmap" do
    url "https://files.pythonhosted.org/packages/bc/68/c186606e4f2bf731abd18044ea201e70c3c244bf468f41368820d197fca5/dotmap-1.3.30.tar.gz"
    sha256 "5821a7933f075fb47563417c0e92e0b7c031158b4c9a6a7e56163479b658b368"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/ce/cc/762dfb036166873f0059f3b7de4565e1b5bc3d6f28a414c13da27e442f99/idna-3.13.tar.gz"
    sha256 "585ea8fe5d69b9181ec1afba340451fba6ba764af97026f92a91d4eef164a242"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/d0/63/68dbb6eb2de9cb10ee4c9c14a0148804425e13c4fb20d61cce69f53106da/packaging-24.2.tar.gz"
    sha256 "c228a6dc5e932d346bc5739379109d49e8853dd8223571c7c5b55260edc0b97f"
  end

  resource "print-color" do
    url "https://files.pythonhosted.org/packages/eb/32/601fd9002509b32d1f9d3ec1e8cc5af9af619def83327adbb1ea18e1502a/print_color-0.4.6.tar.gz"
    sha256 "d3aafc1666c8d31a85fffa6ee8e4f269f5d5e338d685b4e6179915c71867c585"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/6b/6b/a0e95cad1ad7cc3f2c6821fcab91671bd5b78bd42afb357bb4765f29bc41/protobuf-7.34.1.tar.gz"
    sha256 "9ce42245e704cc5027be797c1db1eb93184d44d1cdd71811fb2d9b25ad541280"
  end

  resource "pyobjc-core" do
    url "https://files.pythonhosted.org/packages/b8/b6/d5612eb40be4fd5ef88c259339e6313f46ba67577a95d86c3470b951fce0/pyobjc_core-12.1.tar.gz"
    sha256 "2bb3903f5387f72422145e1466b3ac3f7f0ef2e9960afa9bcd8961c5cbf8bd21"
  end

  resource "pyobjc-framework-cocoa" do
    url "https://files.pythonhosted.org/packages/02/a3/16ca9a15e77c061a9250afbae2eae26f2e1579eb8ca9462ae2d2c71e1169/pyobjc_framework_cocoa-12.1.tar.gz"
    sha256 "5556c87db95711b985d5efdaaf01c917ddd41d148b1e52a0c66b1a2e2c5c1640"
  end

  resource "pyobjc-framework-corebluetooth" do
    url "https://files.pythonhosted.org/packages/4b/25/d21d6cb3fd249c2c2aa96ee54279f40876a0c93e7161b3304bf21cbd0bfe/pyobjc_framework_corebluetooth-12.1.tar.gz"
    sha256 "8060c1466d90bbb9100741a1091bb79975d9ba43911c9841599879fc45c2bbe0"
  end

  resource "pyobjc-framework-libdispatch" do
    url "https://files.pythonhosted.org/packages/26/e8/75b6b9b3c88b37723c237e5a7600384ea2d84874548671139db02e76652b/pyobjc_framework_libdispatch-12.1.tar.gz"
    sha256 "4035535b4fae1b5e976f3e0e38b6e3442ffea1b8aa178d0ca89faa9b8ecdea41"
  end

  resource "pypubsub" do
    url "https://files.pythonhosted.org/packages/c9/ae/873ab0911ba6ae395f05a788cd509af4ade15585740e1f0bc7673775f469/pypubsub-4.0.7.tar.gz"
    sha256 "ec8b5cb147624958320e992602380cc5d0e4b36b1c59844d05e425a3003c09dc"
  end

  resource "pyqrcode" do
    url "https://files.pythonhosted.org/packages/37/61/f07226075c347897937d4086ef8e55f0a62ae535e28069884ac68d979316/PyQRCode-1.2.1.tar.gz"
    sha256 "fdbf7634733e56b72e27f9bce46e4550b75a3a2c420414035cae9d9d26b234d5"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "pyyaml" do
    url "https://files.pythonhosted.org/packages/05/8e/961c0007c59b8dd7729d542c61a4d537767a59645b82a0b521206e1e25c2/pyyaml-6.0.3.tar.gz"
    sha256 "d76623373421df22fb4cf8817020cbb7ef15c725b9d5e45f17e189bfc384190f"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/5f/a4/98b9c7c6428a668bf7e42ebb7c79d576a1c3c1e3ae2d47e674b468388871/requests-2.33.1.tar.gz"
    sha256 "18817f8c57c6263968bc123d237e3b8b08ac046f5456bd1e307ee8f4250d3517"
  end

  resource "tabulate" do
    url "https://files.pythonhosted.org/packages/ec/fe/802052aecb21e3797b8f7902564ab6ea0d60ff8ca23952079064155d1ae1/tabulate-0.9.0.tar.gz"
    sha256 "0095b12bf5966de529c0feb1fa08671671b3368eec77d7ef7ab114be2c068b3c"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c7/24/5f1b3bdffd70275f6661c76461e25f024d5a38a46f04aaca912426a2b1d3/urllib3-2.6.3.tar.gz"
    sha256 "1b62b6884944a57dbe321509ab94fd4d3b307075e0c2eae991ac71ee15ad38ed"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/2c/ee/afaf0f85a9a18fe47a67f1e4422ed6cf1fe642f0ae0a2f81166231303c52/wcwidth-0.7.0.tar.gz"
    sha256 "90e3a7ea092341c44b99562e75d09e4d5160fe7a3974c6fb842a101a95e7eed0"
  end

  def install
    if OS.mac?
      ENV.append_to_cflags "-isysroot #{MacOS.sdk_path}"
      without = ["dbus-fast"]
    else
      without = resources.filter_map { |r| r.name if r.name.start_with?("pyobjc") }
    end
    virtualenv_install_with_resources(without:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/meshtastic --version")
    error_output = "No Serial Meshtastic device detected"
    assert_match error_output, shell_output("#{bin}/meshtastic --info", 1)
    assert_match error_output, shell_output("#{bin}/meshtastic --debug", 1)
    assert_match error_output, shell_output("#{bin}/meshtastic --node", 1)
    support_output = shell_output("#{bin}/meshtastic --support")
    system_name = OS.mac? ? "Darwin" : "Linux"
    machine_pattern = Hardware::CPU.arm? ? /Machine: (arm64|aarch64)/ : /Machine: x86_64/
    assert_match "https://github.com/meshtastic/python/issues", support_output
    assert_match "System: #{system_name}", support_output
    assert_match machine_pattern, support_output
  end
end
