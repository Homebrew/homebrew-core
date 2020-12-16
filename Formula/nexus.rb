class Nexus < Formula
  desc "Repository manager for binary software components"
  homepage "https://www.sonatype.org/"
  url "https://github.com/sonatype/nexus-public/archive/release-3.29.0-02.tar.gz"
  sha256 "eb0c7baec32f3fa252026cfb992eed38a8db8db5f9c0f46d8776b19c6816e114"
  license "EPL-1.0"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/release[._-]v?(\d+(?:[.-]\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "e62561a37e301d5308d28ccaa1d438803f4dc2490a65572d9267c2f35c32b0cd" => :big_sur
    sha256 "09d35ac43dfb7c7674a2e8aaf739fd67f9c238403d958806bee68d33939446b2" => :catalina
    sha256 "8cfd75535043381764845b6fc13c3bf0b30a38087f7639469ee84d0c25940160" => :mojave
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
