class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/registry"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.23.2/nifi-registry-1.23.2-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/1.23.2/nifi-registry-1.23.2-bin.zip"
  sha256 "b6609c1e06e270b54c58b1a5cfabe1b9239db1a12142c27949f37c96f9f7880e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "79b2ee392089ce836bfb131ee755f886f89adfe5b57a99267b05146d69c7d114"
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
