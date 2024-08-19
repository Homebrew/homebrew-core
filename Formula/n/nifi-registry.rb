class NifiRegistry < Formula
  desc "Centralized storage & management of NiFi/MiNiFi shared resources"
  homepage "https://nifi.apache.org/projects/registry"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.27.0/nifi-registry-1.27.0-bin.zip"
  mirror "https://archive.apache.org/dist/nifi/1.27.0/nifi-registry-1.27.0-bin.zip"
  sha256 "e2f9e0e952462b466a4a4d217560a3d60646ec2f194761a1a708440d0a94d541"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "da724538b430830cff57d2e3743f65a7aee7c35d2b2dc0f7fcd47a5076fa3532"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da724538b430830cff57d2e3743f65a7aee7c35d2b2dc0f7fcd47a5076fa3532"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da724538b430830cff57d2e3743f65a7aee7c35d2b2dc0f7fcd47a5076fa3532"
    sha256 cellar: :any_skip_relocation, sonoma:         "da724538b430830cff57d2e3743f65a7aee7c35d2b2dc0f7fcd47a5076fa3532"
    sha256 cellar: :any_skip_relocation, ventura:        "da724538b430830cff57d2e3743f65a7aee7c35d2b2dc0f7fcd47a5076fa3532"
    sha256 cellar: :any_skip_relocation, monterey:       "da724538b430830cff57d2e3743f65a7aee7c35d2b2dc0f7fcd47a5076fa3532"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9afcee634bc562b5d2cac714761b28d203b5436b0decfc3c9c8d66142bf61f13"
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
