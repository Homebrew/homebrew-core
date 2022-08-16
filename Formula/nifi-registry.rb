class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/registry"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.17.0/nifi-registry-1.17.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/1.17.0/nifi-registry-1.17.0-bin.zip"
  sha256 "0dc96665f81233b64bcc318fcdd8d88cb92a9d62588b44b430ddb45e915bfa01"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "18cc7714fc5c0efc3713f183646399771bcc473ac755112c8c9460f1b983e26e"
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
