class Nexus < Formula
  desc "Repository manager for binary software components"
  homepage "https://www.sonatype.org/"
  url "https://github.com/sonatype/nexus-public/archive/release-3.28.1-01.tar.gz"
  sha256 "2b17b3fee3fd81b299bf7d5d818d248a1c82554580aa51210c78f89f2a5b2c37"
  license "EPL-1.0"

  livecheck do
    url "https://github.com/sonatype/nexus-public/releases/latest"
    regex(%r{href=.*?/tag/release[._-]v?(\d+(?:[.-]\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "de3a5e6934087a0d7a52ddfcd5bf9c2b547ee19812cff2316afaca91f638fb82" => :big_sur
    sha256 "3eb3a774ba71339596c7a255a03e7dd88a003cf9326d51c6e6f32d99bff0bd8a" => :catalina
    sha256 "aa2dde0621bc26d80d87a2b325b9ba37b0a9c36dcdd57b66c30a95320be19cae" => :mojave
  end

  depends_on "maven" => :build
  depends_on "openjdk@8"

  uses_from_macos "unzip" => :build

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@8"].opt_prefix
    system "mvn", "install", "-DskipTests"
    system "unzip", "-o", "-d", "target", "assemblies/nexus-base-template/target/nexus-base-template-#{version}.zip"

    rm_f Dir["target/nexus-base-template-#{version}/bin/*.bat"]
    rm_f "target/nexus-base-template-#{version}/bin/contrib"
    libexec.install Dir["target/nexus-base-template-#{version}/*"]

    env = {
      JAVA_HOME:  Formula["openjdk@8"].opt_prefix,
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

  plist_options manual: "nexus start"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>com.sonatype.nexus</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/nexus</string>
            <string>start</string>
          </array>
          <key>RunAtLoad</key>
        <true/>
        </dict>
      </plist>
    EOS
  end

  test do
    mkdir "data"
    fork do
      ENV["NEXUS_KARAF_DATA"] = testpath/"data"
      exec "#{bin}/nexus", "server"
    end
    sleep 60
    assert_match "<title>Nexus Repository Manager</title>", shell_output("curl --silent --fail http://localhost:8081")
  end
end
