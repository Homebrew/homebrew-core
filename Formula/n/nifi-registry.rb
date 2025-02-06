class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/projects/registry"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/2.2.0/nifi-registry-2.2.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/2.2.0/nifi-registry-2.2.0-bin.zip"
  sha256 "3d6f376184ed0f2bbee676c3f2a6023b1105cf615a2860a5db2c1e34a75bbdba"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "639eb26a31e1af224b4a186df13f7a3f371f45d040970e51bd9c963dd6d4b962"
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
