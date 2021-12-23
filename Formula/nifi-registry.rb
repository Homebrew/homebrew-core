class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/registry"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.15.2/nifi-registry-1.15.2-bin.tar.gz"
  mirror "https://archive.apache.org/dist/nifi/1.15.2/nifi-registry-1.15.2-bin.tar.gz"
  sha256 "9dedf1fd533c6007768f2887eae078aec4a62ea04095fcb01344257a370107da"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a897d418ce7bb98b522ae9ea22b749caac93b0dc970b2d3a1c64a5bad1e02416"
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
