class Nexus < Formula
  desc "Repository manager for binary software components"
  homepage "https://www.sonatype.org/"
  url "https://github.com/sonatype/nexus-public/archive/release-3.30.1-01.tar.gz"
  sha256 "acb429b3357d12114adb04b0b835b0ff26cab4ad6d6a5b8e28b587cc53468e5b"
  license "EPL-1.0"

  # As of writing, upstream is publishing both v2 and v3 releases. The "latest"
  # release on GitHub isn't reliable, as it can point to a release from either
  # one of these major versions depending on which was published most recently.
  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(\d+(?:[.-]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "a435f6ace0b7a4a54d9f9cd3afa671c5e60b8a68c49627022db9ae10d0e8d057"
    sha256 cellar: :any_skip_relocation, catalina: "a0f67c9696e2f72f6e6d897dab4bcac5d7afdc58107faa925e0a22f887d037e5"
    sha256 cellar: :any_skip_relocation, mojave:   "db4d04ddd0cf2103875bf38bf90129f511542cff117e2bd70321a569ba0129ec"
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
    sleep 100
    assert_match "<title>Nexus Repository Manager</title>", shell_output("curl --silent --fail http://localhost:8081")
  end
end
