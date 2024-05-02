class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/projects/registry"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.25.0/nifi-registry-1.25.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/1.25.0/nifi-registry-1.25.0-bin.zip"
  sha256 "ae8e4c04c1fe9d4082582ae1e68353aba8e1c67ac8bee788e309717e05f983e1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "38f0277859e9df49359e9ebbeba5ca581d57efc7a17da5c11564c4d506ad60a8"
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
