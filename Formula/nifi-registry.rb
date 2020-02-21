class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/registry"
  url "https://www.apache.org/dyn/closer.lua?path=nifi/nifi-registry/nifi-registry-0.5.0/nifi-registry-0.5.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/nifi/nifi-registry/nifi-registry-0.5.0/nifi-registry-0.5.0-bin.tar.gz"
  sha256 "6bf16eb1e73709b2723aaeccd7dddc08ff64ce7f46ef4ed2b0a36e24773b7f64"

  bottle :unneeded

  def install
    libexec.install Dir["*"]
    rm Dir[libexec/"bin/*.bat"]

    bin.install libexec/"bin/nifi-registry.sh" => "nifi-registry"
    bin.env_script_all_files libexec/"bin/", :NIFI_REGISTRY_HOME => libexec
  end

  test do
    output = shell_output("#{bin}/nifi-registry status")
    assert_match "Apache NiFi Registry is not running", output
  end
end
