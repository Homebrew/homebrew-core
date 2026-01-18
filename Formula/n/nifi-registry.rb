class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/projects/registry"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/2.7.2/nifi-registry-2.7.2-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/2.7.2/nifi-registry-2.7.2-bin.zip"
  sha256 "aca7cb608c1bfb5641689d3df1a671c9dfc38852db894d99a3de2a6ba2d1e1bb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fc13198b78a0258f5bc4305a96ad97c46c7386a162f6a1e25b412ce790076025"
  end

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
