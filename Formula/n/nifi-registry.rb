class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/projects/registry"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/2.3.0/nifi-registry-2.3.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/2.3.0/nifi-registry-2.3.0-bin.zip"
  sha256 "49a174e98f834b85d1ec7a642ab67bafe4b5f5cf9825ea22d66eea57aa72b7bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8da361c29b94ac86edfa548947aa9b0cf72a43bb4ac3f4e1e1d4c3ce945c9dfa"
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
