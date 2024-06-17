class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/projects/registry"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.26.0/nifi-registry-1.26.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/1.26.0/nifi-registry-1.26.0-bin.zip"
  sha256 "af7b39f6bceacfd4e2e4f8805e9da9f7faea3ea9a7b031748f51c6cf72fd7021"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ae9efc224304b907e2e3c1704ad4b781ce837873777578075caa294ea48c262f"
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
