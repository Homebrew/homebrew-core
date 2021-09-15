class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/registry"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.14.0/nifi-registry-1.14.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/nifi/1.14.0/nifi-registry-1.14.0-bin.tar.gz"
  sha256 "4fac3cab66e0e2eba7d9f7bed27f3783942e01e67c79bba404309bbf9b5262a9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d726c4411b3cc143d6d906ced9df10aa4fec1b42d58c6c13d5405fe010bad27f"
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
