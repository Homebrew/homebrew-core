class Carrot2 < Formula
  desc "Search results clustering engine"
  homepage "https://project.carrot2.org"
  url "https://github.com/carrot2/carrot2.git",
      tag:      "release/4.1.0",
      revision: "84fab40554501d653194c8f233ec4b137cd881ae"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "390e44722413183c996b9e5f777fd0e4aa3ba41e743c1271925aeb1a0563f447" => :big_sur
    sha256 "7dd4787aef0833a6147df58a89d9c3183ac96cddc724f6ae04ac39bb7b5e95f2" => :catalina
    sha256 "4499a0e7e0bc182c03b01aafb70e189c7fc6dbb04308ba92ba2dc2ffa8904202" => :mojave
    sha256 "952d43fdc6efa2a79d7cd206561f6392ef65f6f53699f584d26e5b9e8b7f8dde" => :high_sierra
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
    # Make possible to build the formula with the latest available in Homebrew gradle
    inreplace "gradle/validation/check-environment.gradle",
      /expectedGradleVersion = '[^']+'/,
      "expectedGradleVersion = '#{Formula["gradle"].version}'"

    system "gradle", "assemble"

    cd "distribution/build/dist" do
      inreplace "dcs/conf/logging/appender-file.xml", "${dcs:home}/logs", var/"log/carrot2"
      libexec.install Dir["*"]
    end

    (bin/"carrot2").write_env_script "#{libexec}/dcs/dcs.sh",
      JAVA_CMD:    "exec '#{Formula["openjdk"].opt_bin}/java'",
      SCRIPT_HOME: libexec/"dcs"
  end

  plist_options manual: "carrot2"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
      "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>#{plist_name}</string>
          <key>RunAtLoad</key>
          <true/>
          <key>AbandonProcessGroup</key>
          <true/>
          <key>WorkingDirectory</key>
          <string>#{opt_libexec}</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{opt_bin}/carrot2</string>
          </array>
        </dict>
      </plist>
    EOS
  end

  test do
    port = free_port
    fork { exec bin/"carrot2", "--port", port.to_s }
    sleep 5
    assert_match "Lingo", shell_output("curl -s localhost:#{port}/service/list")
  end
end
