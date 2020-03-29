class Artifactory < Formula
  desc "Manages binaries"
  homepage "https://www.jfrog.com/artifactory/"
  url "https://dl.bintray.com/jfrog/artifactory/jfrog-artifactory-oss-6.18.1.zip"
  sha256 "f5475d88f0f30afe7f5b94192c82bbe7cf832b8a07b2f8a110f60264c1a6adc1"

  bottle :unneeded

  depends_on "openjdk"

  def install
    # Remove Windows binaries
    rm_f Dir["bin/*.bat"]
    rm_f Dir["bin/*.exe"]

    # Set correct working directory
    inreplace "bin/artifactory.sh",
      'export ARTIFACTORY_HOME="$(cd "$(dirname "${artBinDir}")" && pwd)"',
      "export ARTIFACTORY_HOME=#{libexec}"

    libexec.install Dir["*"]

    # Launch Script
    bin.install libexec/"bin/artifactory.sh"
    # Memory Options
    bin.install libexec/"bin/artifactory.default"

    bin.env_script_all_files libexec/"bin", :JAVA_HOME => Formula["openjdk"].opt_prefix
  end

  def post_install
    # Create persistent data directory. Artifactory heavily relies on the data
    # directory being directly under ARTIFACTORY_HOME.
    # Therefore, we symlink the data dir to var.
    data = var/"artifactory"
    data.mkpath

    libexec.install_symlink data => "data"
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/artifactory/libexec/bin/artifactory.sh"

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
