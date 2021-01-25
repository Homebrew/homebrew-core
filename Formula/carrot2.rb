class Carrot2 < Formula
  desc "Search results clustering engine"
  homepage "https://project.carrot2.org"
  url "https://github.com/carrot2/carrot2.git",
      tag:      "release/4.1.0",
      revision: "84fab40554501d653194c8f233ec4b137cd881ae"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "e3c921aca1359a03cf59c4c86398bb60d40bfda7016d724a3bdaf142f217ce1c" => :big_sur
    sha256 "2bc7f90be9567d859e9536d567bd3337a8c7947cd064f4bf8a7e675f3e0e672a" => :catalina
    sha256 "575a9813da9b3211549e0a9a9b77d080a979c7dc4387809ba9b7184aeb22eb47" => :mojave
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
