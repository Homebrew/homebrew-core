class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/registry"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/nifi-registry/nifi-registry-0.4.0/nifi-registry-0.4.0-bin.tar.gz"
  sha256 "bcb96e9039829777f491dc64c241bb8e0c1863293b08e61b6f7781fa55bb974c"

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
