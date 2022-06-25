class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/registry"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.16.3/nifi-registry-1.16.3-bin.tar.gz"
  mirror "https://archive.apache.org/dist/nifi/1.16.3/nifi-registry-1.16.3-bin.tar.gz"
  sha256 "fa8ef5097d9385ac9efe06e836fbff37d9ecc955b8495fba798a91f196fd4a52"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5e28e566f3ec8f0200d7a785df681bd2a71d7a119d45cbad001999992265f513"
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
