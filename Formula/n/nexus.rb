class Nexus < Formula
  desc "Repository manager for binary software components"
  homepage "https://www.sonatype.com/"
  url "https://github.com/sonatype/nexus-public/archive/refs/tags/release-3.76.1-01.tar.gz"
  sha256 "e2fe13994f4ffcc3e5389ea90e14a1dcc7af92ce37015a961f89bbf151d29c86"
  license "EPL-1.0"

  # As of writing, upstream is publishing both v2 and v3 releases. The "latest"
  # release on GitHub isn't reliable, as it can point to a release from either
  # one of these major versions depending on which was published most recently.
  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(\d+(?:[.-]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, sonoma:       "8382a3070ff6768a2f9946744a34875ab23981068beecb5339e02b0afadab719"
    sha256 cellar: :any_skip_relocation, ventura:      "a5684351606c7ea7750ce7934fcea0d3e6b64f50fa0d9739c07e33f96288151b"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "30c5f8c306c9382151e2ad703e505a6353beba3b09359f8f7b4be440b3ae591a"
  end

  depends_on "maven" => :build
  depends_on "openjdk@17"

  uses_from_macos "unzip" => :build

  on_macos do
    depends_on arch: :x86_64 # due to node binary fetched by frontend-maven-plugin
  end

  def install
    # Workaround build error: Couldn't find package "@sonatype/nexus-ui-plugin@workspace:*"
    # Ref: https://github.com/sonatype/nexus-public/issues/417
    # Ref: https://github.com/sonatype/nexus-public/issues/432#issuecomment-2663250153
    inreplace ["components/nexus-rapture/package.json", "plugins/nexus-coreui-plugin/package.json"],
              '"@sonatype/nexus-ui-plugin": "workspace:*"',
              '"@sonatype/nexus-ui-plugin": "*"'

    ENV["JAVA_HOME"] = Language::Java.java_home("17")
    system "mvn", "install", "-DskipTests", "-Dpublic"
    system "unzip", "-o", "-d", "target", "assemblies/nexus-base-template/target/nexus-base-template-#{version}.zip"

    rm(Dir["target/nexus-base-template-#{version}/bin/*.bat"])
    rm_r("target/nexus-base-template-#{version}/bin/contrib")
    libexec.install Dir["target/nexus-base-template-#{version}/*"]

    env = {
      JAVA_HOME:  ENV["JAVA_HOME"],
      KARAF_DATA: "${NEXUS_KARAF_DATA:-#{var}/nexus}",
      KARAF_LOG:  "#{var}/log/nexus",
      KARAF_ETC:  "#{etc}/nexus",
    }

    (bin/"nexus").write_env_script libexec/"bin/nexus", env
  end

  def post_install
    mkdir_p "#{var}/log/nexus" unless (var/"log/nexus").exist?
    mkdir_p "#{var}/nexus" unless (var/"nexus").exist?
    mkdir "#{etc}/nexus" unless (etc/"nexus").exist?
  end

  service do
    run [opt_bin/"nexus", "start"]
  end

  test do
    mkdir "data"
    fork do
      ENV["NEXUS_KARAF_DATA"] = testpath/"data"
      exec bin/"nexus", "server"
    end
    sleep 50
    sleep 50 if OS.mac? && Hardware::CPU.intel?
    assert_match "<title>Sonatype Nexus Repository</title>", shell_output("curl --silent --fail http://localhost:8081")
  end
end
