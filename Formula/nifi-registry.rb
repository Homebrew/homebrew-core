class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/registry"
  url "https://www.apache.org/dyn/closer.lua?path=nifi/nifi-registry/nifi-registry-0.6.0/nifi-registry-0.6.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/nifi/nifi-registry/nifi-registry-0.6.0/nifi-registry-0.6.0-bin.tar.gz"
  sha256 "e52d07e5689dbab5a04fa6afb4e89b316980daac781144c9651aa81a68c38068"

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
