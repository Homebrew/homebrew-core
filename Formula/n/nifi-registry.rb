class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/projects/registry"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/2.11.0/nifi-registry-2.11.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/2.11.0/nifi-registry-2.11.0-bin.zip"
  sha256 "7d8b9232088b60718010ddc48f6c0551bf52074eec48af51a62d24d420216c78"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d75de0d7010561fabaa80766acff1cde2c9df5dc22b08190163e605f9c01ec51"
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
