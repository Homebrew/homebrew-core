class MqttxCli < Formula
  desc "Open source MQTT 5.0 CLI client and MQTT X on the command-line"
  homepage "https://github.com/emqx/MQTTX/tree/main/cli"
  url "https://github.com/emqx/MQTTX/releases/download/v1.8.0/mqttx-cli.tar.gz"
  version "1.8.0"
  sha256 "d9b8db76bb966fa5e9fcdc3b1fc3a17e3302c5dc9cb6f05e20eead814b37241a"
  license "Apache License 2.0"

  def install
    bin.install "mqttx"
  end
end
