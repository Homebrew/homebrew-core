class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/registry"
  url "https://www.apache.org/dyn/closer.lua?path=nifi/nifi-registry/nifi-registry-0.7.0/nifi-registry-0.7.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/nifi/nifi-registry/nifi-registry-0.7.0/nifi-registry-0.7.0-bin.tar.gz"
  sha256 "6e4ac84a60bdb49adeaa6e21c2c2eb95909efe9bb3d1e1e9c8738ef0599d7364"
  license "Apache-2.0"

  livecheck do
    url :stable
  end

  bottle :unneeded

  def install
    libexec.install Dir["*"]
    rm Dir[libexec/"bin/*.bat"]

    bin.install libexec/"bin/nifi-registry.sh" => "nifi-registry"
    bin.env_script_all_files libexec/"bin/", NIFI_REGISTRY_HOME: libexec
  end

  test do
    output = shell_output("#{bin}/nifi-registry status")
    assert_match "Apache NiFi Registry is not running", output
  end
end
