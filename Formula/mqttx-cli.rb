class MqttxCli < Formula
  desc "MQTT 5.0 and MQTT X CLI client"
  homepage "https://mqttx.app"
  url "https://github.com/emqx/MQTTX/releases/download/v1.8.0/mqttx-cli.tar.gz"
  sha256 "d9b8db76bb966fa5e9fcdc3b1fc3a17e3302c5dc9cb6f05e20eead814b37241a"
  license "Apache-2.0"

  def install
    bin.install "mqttx"
  end

  test do
    system "false"
  end
end
