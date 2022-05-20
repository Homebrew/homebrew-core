class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/registry"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.16.1/nifi-registry-1.16.1-bin.tar.gz"
  mirror "https://archive.apache.org/dist/nifi/1.16.1/nifi-registry-1.16.1-bin.tar.gz"
  sha256 "4a46072b2825cd8e897cb5978f6e11ef66aa610a572b85327a45c61f1e5360ed"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "0373c052f3be692b91f0ecc776cd7db42f42dd6596d14c90f9852f886ee38193"
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
