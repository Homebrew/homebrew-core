class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/registry"
  url "https://www.apache.org/dyn/closer.lua?path=nifi/nifi-registry/nifi-registry-0.8.0/nifi-registry-0.8.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/nifi/nifi-registry/nifi-registry-0.8.0/nifi-registry-087.0-bin.tar.gz"
  sha256 "db9f390eb4e1f99fb861c437be95729dfcb203f49de4b9cb3130a612a4ae288d"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
  end

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    rm Dir[libexec/"bin/*.bat"]

    bin.install libexec/"bin/nifi-registry.sh" => "nifi-registry"
    bin.env_script_all_files libexec/"bin/",
                             Language::Java.overridable_java_home_env.merge(NIFI_REGISTRY_HOME: libexec)
  end

  test do
    output = shell_output("#{bin}/nifi-registry status")
    assert_match "Apache NiFi Registry is not running", output
  end
end
