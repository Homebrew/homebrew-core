class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/registry"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.23.1/nifi-registry-1.23.1-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/1.23.1/nifi-registry-1.23.1-bin.zip"
  sha256 "d55ccc93584bca61390ddea450d27508d6b8918a80d74d847c26ec090347b10c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f94eb878d0ab1ce798b35806f176c4f1262f4d38023f1a35846ea7f3fdc652db"
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
