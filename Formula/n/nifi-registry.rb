class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/projects/registry"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/2.9.0/nifi-registry-2.9.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/2.9.0/nifi-registry-2.9.0-bin.zip"
  sha256 "4ee93c806767e6fd73458f32373972e42e003e452538be047d5f36eeb372c83d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bdc47349d6b40a244aecbee3b08c501975114cfd1efa9dc2e9ff862c3d8d2738"
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
