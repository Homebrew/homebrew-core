class Artifactory < Formula
  desc "Manages binaries"
  homepage "https://www.jfrog.com/artifactory/"
  # v7 is available but does contain a number of pre-builts that need to be avoided.
  # Note that just using the source archive is not sufficient.
  url "https://releases.jfrog.io/artifactory/bintray-artifactory/org/artifactory/oss/jfrog-artifactory-oss/6.23.15/jfrog-artifactory-oss-6.23.15.zip"
  sha256 "c342b9949aa42d928f25704105fd9f522835e9344e56ecc24e63a899c2948041"
  license "AGPL-3.0-or-later"

  livecheck do
    url "https://releases.jfrog.io/artifactory/bintray-artifactory/org/artifactory/oss/jfrog-artifactory-oss/"
    regex(/href=.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b601b9bec08834496b2412d3255548ad0f03d3a0305a1c8d879e3735b0d695f5"
    sha256 cellar: :any_skip_relocation, big_sur:       "1e63e1246239ddcbc0ad1120731b0631d03fab85a546457de4003036a2cb38bf"
    sha256 cellar: :any_skip_relocation, catalina:      "1e63e1246239ddcbc0ad1120731b0631d03fab85a546457de4003036a2cb38bf"
    sha256 cellar: :any_skip_relocation, mojave:        "1e63e1246239ddcbc0ad1120731b0631d03fab85a546457de4003036a2cb38bf"
  end

  depends_on "openjdk"

  def install
    # Remove Windows binaries
    rm_f Dir["bin/*.bat"]
    rm_f Dir["bin/*.exe"]

    # Prebuilts
    rm_rf "bin/metadata"

    # Set correct working directory
    inreplace "bin/artifactory.sh",
      'export ARTIFACTORY_HOME="$(cd "$(dirname "${artBinDir}")" && pwd)"',
      "export ARTIFACTORY_HOME=#{libexec}"

    libexec.install Dir["*"]

    # Launch Script
    bin.install libexec/"bin/artifactory.sh"
    # Memory Options
    bin.install libexec/"bin/artifactory.default"

    bin.env_script_all_files libexec/"bin", JAVA_HOME: Formula["openjdk"].opt_prefix
  end

  def post_install
    # Create persistent data directory. Artifactory heavily relies on the data
    # directory being directly under ARTIFACTORY_HOME.
    # Therefore, we symlink the data dir to var.
    data = var/"artifactory"
    data.mkpath

    libexec.install_symlink data => "data"
  end

  plist_options manual: "#{HOMEBREW_PREFIX}/opt/artifactory/libexec/bin/artifactory.sh"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>com.jfrog.artifactory</string>

          <key>WorkingDirectory</key>
          <string>#{libexec}</string>

          <key>Program</key>
          <string>#{bin}/artifactory.sh</string>

          <key>KeepAlive</key>
          <true/>
        </dict>
      </plist>
    EOS
  end

  test do
    assert_match "Checking arguments to Artifactory", pipe_output("#{bin}/artifactory.sh check")
  end
end
