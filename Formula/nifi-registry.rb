class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/registry"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.15.0/nifi-registry-1.15.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist//nifi/1.15.0/nifi-registry-1.15.0-bin.tar.gz"
  sha256 "dec430d61057f134a79ca0af0b3cfe14ebf913ebf15a5882d5d19d0f9cc094b7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5755a0b3cc783bf884fb9f783f00a31c83f5b48bdb3f32cb1ef93a4bfc0aaa64"
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
