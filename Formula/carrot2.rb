class Carrot2 < Formula
  desc "Search results clustering engine"
  homepage "https://project.carrot2.org"
  url "https://github.com/carrot2/carrot2.git",
      tag:      "release/4.2.1",
      revision: "936bcf7fa48e03fafffdf4e6f15b36074d161e6e"
  license "Apache-2.0"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, big_sur:  "378bc81bc95cdfc71b6b9e08058516e40f8bd8446d25fc65cc6e7d7a3840801e"
    sha256 cellar: :any_skip_relocation, catalina: "7ade89023e00a6fc71b7aa5f3fd8d5c9e4a806248e5aec30cf47d0252d48c523"
    sha256 cellar: :any_skip_relocation, mojave:   "cc31066d605e9319d118fa02ccabe747772151824e80c53d9940ed21a7853e42"
  end

  # Switch to `gradle` when carrot2 supports Gradle 7+
  depends_on "gradle@6" => :build
  depends_on "openjdk"

  def install
    # Make possible to build the formula with the latest available in Homebrew gradle
    inreplace "gradle/validation/check-environment.gradle",
      /expectedGradleVersion = '[^']+'/,
      "expectedGradleVersion = '#{Formula["gradle@6"].version}'"

    system "gradle", "assemble", "--no-daemon"

    cd "distribution/build/dist" do
      inreplace "dcs/conf/logging/appender-file.xml", "${dcs:home}/logs", var/"log/carrot2"
      libexec.install Dir["*"]
    end

    (bin/"carrot2").write_env_script "#{libexec}/dcs/dcs",
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
