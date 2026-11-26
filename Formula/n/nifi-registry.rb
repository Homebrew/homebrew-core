class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/projects/registry"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/2.13.0/nifi-registry-2.13.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/2.13.0/nifi-registry-2.13.0-bin.zip"
  sha256 "a14af7282f9a86b9c885449e988b811256e4633aebe0e6cdf04258d3ca65a78c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f109f57f6a1c37a6e4b543646ca68f9cd6104d537c5b0b190d82f07909a646d7"
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
