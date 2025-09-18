class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/projects/registry"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/2.5.0/nifi-registry-2.5.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/2.5.0/nifi-registry-2.5.0-bin.zip"
  sha256 "d8360cc2853d3899ab387b2942b5862bd94df95c01d06112f71b02f7c8b31af4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1fa04b57c6fda1feb4a96a25241d4081907177dc0e06ca83cc8b1cc43d747747"
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
