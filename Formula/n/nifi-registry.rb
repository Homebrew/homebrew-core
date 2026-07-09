class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/projects/registry"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/2.10.0/nifi-registry-2.10.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/2.10.0/nifi-registry-2.10.0-bin.zip"
  sha256 "867afb9a17797966c417bfaa8c08c98721e832859210ddb2c1565851e0a5c5d8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d9c24edfc4bfde65e4d2551a6417ef6ea4eb2ce52b5d296aa32cc2a97be5d9b4"
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
