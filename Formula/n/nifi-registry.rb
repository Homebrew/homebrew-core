class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/projects/registry"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/2.8.0/nifi-registry-2.8.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/2.8.0/nifi-registry-2.8.0-bin.zip"
  sha256 "2cdf438094662bfa95ee72ed627223e486d3362c8ad7076e410b0e2ffea573b0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9c3053a0b2329764bbfd6f7b58e23ddc461b2db9f484a4666d68076d5318e579"
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
