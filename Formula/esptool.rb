class Esptool < Formula
  include Language::Python::Virtualenv

  desc "ESP8266 and ESP32 serial bootloader utility"
  homepage "https://github.com/espressif/esptool"
  url "https://files.pythonhosted.org/packages/9c/c8/28f21b3d3b5e1f1d249be52cdd91793c8c3f7c4f4f255ece7d50984fb05d/esptool-3.1.tar.gz"
  sha256 "ec6b943c53b4d71f87f98776333d5b4b99905766898a7002c28a9090b92b2de4"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "e2916044d6ce93795993340af2904bc088324c54b238f0663f672b35d5d2ff01"
    sha256 cellar: :any,                 big_sur:       "286a2dbf4c4243d0fc244c07d9e41d2eea34e1b60d686b310eb1246f216854b2"
    sha256 cellar: :any,                 catalina:      "c88e132957e5b312946aea44eb0aded7dab11a64fa629190af16ab4f317d496b"
    sha256 cellar: :any,                 mojave:        "0905b46bbefd70aa8a0666651cd51b0664b8390f85c1353d087aab0de5559a1a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b719d2fdc74b53c3bcb4bf507120d00dd08ae4562e2a1ebcccd752164cfdf8c5"
  end

  depends_on "rust" => :build
  depends_on "python@3.10"
  depends_on "six"

  resource "bitstring" do
    url "https://files.pythonhosted.org/packages/4c/b1/80d58eeb21c9d4ca739770558d61f6adacb13aa4908f4f55e0974cbd25ee/bitstring-3.1.9.tar.gz"
    sha256 "a5848a3f63111785224dca8bb4c0a75b62ecdef56a042c8d6be74b16f7e860e7"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/10/91/90b8d4cd611ac2aa526290ae4b4285aa5ea57ee191c63c2f3d04170d7683/cryptography-35.0.0.tar.gz"
    sha256 "9933f28f70d0517686bd7de36166dda42094eac49415459d9bdf5e7df3e0086d"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/bf/3d/3d909532ad541651390bf1321e097404cbd39d1d89c2046f42a460220fb3/ecdsa-0.17.0.tar.gz"
    sha256 "b9f500bb439e4153d0330610f5d26baaf18d17b8ced1bc54410d189385ea68aa"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/0f/86/e19659527668d70be91d0369aeaa055b4eb396b0f387a4f92293a20035bd/pycparser-2.20.tar.gz"
    sha256 "2d475327684562c3a96cc71adf7dc8c4f0565175cf86b6d7a404ff4c771f15f0"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "reedsolo" do
    url "https://files.pythonhosted.org/packages/c8/cb/bb2ddbd00c9b4215dd57a2abf7042b0ae222b44522c5eb664a8fd9d786da/reedsolo-1.5.4.tar.gz"
    sha256 "b8b25cdc83478ccb06361a0e8fadc27b376a3dfabbb1dc6bb583a998a22c0127"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    require "base64"

    assert_match version.to_s, shell_output("#{bin}/esptool.py version")
    assert_match "usage: espefuse.py", shell_output("#{bin}/espefuse.py --help")
    assert_match version.to_s, shell_output("#{bin}/espsecure.py --help")

    (testpath/"helloworld-esp8266.bin").write ::Base64.decode64 <<~EOS
      6QIAICyAEEAAgBBAMAAAAFDDAAAAgP4/zC4AQMwkAEAh/P8SwfAJMQH8/8AAACH5/wH6/8AAAAb//wAABvj/AACA/j8QAAAASGVsbG8gd29ybGQhCgAAAAAAAAAAAAAD
    EOS

    result = shell_output("#{bin}/esptool.py image_info #{testpath}/helloworld-esp8266.bin")
    assert_match "4010802c", result
  end
end
