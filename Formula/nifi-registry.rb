class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/registry"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/nifi-registry/nifi-registry-0.1.0/nifi-registry-0.1.0-bin.tar.gz"
  sha256 "e7b4c66be02541df735b06b77df95cd3d5cf68b450ed8e29f0596bce095ccf4d"

  bottle :unneeded

  def install
    libexec.install Dir["*"]

    ENV["NIFI_REGISTRY_HOME"] = libexec

    bin.install libexec/"bin/nifi-registry.sh" => "nifi-registry"
    bin.env_script_all_files libexec/"bin/", :NIFI_REGISTRY_HOME => libexec
  end

  test do
    system bin/"nifi-registry", "status"
  end
end
