class Nexus < Formula
  desc "Repository manager for binary software components"
  homepage "https://www.sonatype.org/"
  url "https://github.com/sonatype/nexus-public/archive/release-3.33.0-01.tar.gz"
  sha256 "9ee5ef637d72e1c6e3243ccc95302ea8bca54aa9856f728e2fe5d100ebddebc9"
  license "EPL-1.0"

  # As of writing, upstream is publishing both v2 and v3 releases. The "latest"
  # release on GitHub isn't reliable, as it can point to a release from either
  # one of these major versions depending on which was published most recently.
  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(\d+(?:[.-]\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "bafa77cd699c8c1d44827cf3b222a8d91fad2ae405e09d3b79faaae30c532394"
    sha256 cellar: :any_skip_relocation, catalina: "5bd104d19a13c59249efad40dd99a23cdc30c4c7dcdf573e63af39ba0eacd30d"
    sha256 cellar: :any_skip_relocation, mojave:   "f80e325a41920421822cd3edf34767893b1b92872f55d70ddd89248fea4ea44e"
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
