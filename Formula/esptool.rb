class Esptool < Formula
  include Language::Python::Virtualenv

  desc "ESP8266 and ESP32 serial bootloader utility"
  homepage "https://github.com/espressif/esptool"
  url "https://github.com/espressif/esptool/archive/v2.5.1.tar.gz"
  sha256 "6730b69d8ba09ff09f845873eaeef352bd18a4ee24b31b0898fd8fc5f178c037"

  bottle do
    cellar :any_skip_relocation
    sha256 "c5c0f0622515e9969ee8102d5b884f8b8e918dd892deea2292a3ad6f70fc297f" => :mojave
    sha256 "4603bacc0f295533f8dde969a4512ccfa2b1e55b3b18a3fd57b4633386033de2" => :high_sierra
    sha256 "46fd1318d852fd5c573bee52675a647ed4cb524fa7a5eb3b4bc58b86f6a18f6d" => :sierra
  end

  depends_on "python"

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/f9/e5/99ebb176e47f150ac115ffeda5fedb6a3dbb3c00c74a59fd84ddf12f5857/ecdsa-0.13.tar.gz"
    sha256 "64cf1ee26d1cde3c73c6d7d107f835fed7c6a2904aef9eac223d57ad800c43fa"
  end

  resource "pyaes" do
    url "https://files.pythonhosted.org/packages/44/66/2c17bae31c906613795711fc78045c285048168919ace2220daa372c7d72/pyaes-1.6.1.tar.gz"
    sha256 "02c1b1405c38d3c370b085fb952dd8bea3fadcee6411ad99f312cc129c536d8f"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/cc/74/11b04703ec416717b247d789103277269d567db575d2fd88f25d9767fe3d/pyserial-3.4.tar.gz"
    sha256 "6e2d401fdee0eab996cf734e67773a0143b932772ca8b42451440cfed942c627"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    require "base64"

    assert_match(/#{version}/, shell_output("#{bin}/esptool.py version"))
    assert_match(/#{version}/, shell_output("#{bin}/espefuse.py --help"))
    assert_match(/#{version}/, shell_output("#{bin}/espsecure.py --help"))

    (testpath/"helloworld-esp8266.bin").write ::Base64.decode64 <<~EOS
      6QIAICyAEEAAgBBAMAAAAFDDAAAAgP4/zC4AQMwkAEAh/P8SwfAJMQH8/8AAACH5/wH6/8AAAAb//wAABvj/AACA/j8QAAAASGVsbG8gd29ybGQhCgAAAAAAAAAAAAAD
    EOS

    result = shell_output("#{bin}/esptool.py image_info #{testpath}/helloworld-esp8266.bin")
    assert_match "4010802c", result
  end
end
