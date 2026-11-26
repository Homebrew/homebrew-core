class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/projects/registry"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/2.13.0/nifi-registry-2.13.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/2.13.0/nifi-registry-2.13.0-bin.zip"
  sha256 "a14af7282f9a86b9c885449e988b811256e4633aebe0e6cdf04258d3ca65a78c"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "d86ad10fa1f62c2e9bd13053a13a9235dcc1a0cc28dc7c8596ade1aa95da5fd6"
    sha256 cellar: :any_skip_relocation, all: "552b9477a7ac9040fd87b36594b96bb7870a7bfd16cfb0887d8b1aeda2e8490c"
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
