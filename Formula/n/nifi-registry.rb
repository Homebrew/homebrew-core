class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/projects/registry"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/2.6.0/nifi-registry-2.6.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/2.6.0/nifi-registry-2.6.0-bin.zip"
  sha256 "08f0cbd8a03c8429938d9a419f4603bcd377c89e901e1c72fb817d265e3fa4de"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "139df7413fd3d51ed9e762e9e4a97cc05ebdeb38ed448cede9e5913f77932525"
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
