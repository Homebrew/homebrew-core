class Carrot2 < Formula
  desc "Search results clustering engine"
  homepage "https://project.carrot2.org"
  url "https://github.com/carrot2/carrot2.git",
      tag:      "release/4.0.0",
      revision: "6a5e2ff984b3ec60375fd475c7cdcd25f7403beb"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "a194d103ec94747cc1ff6b1c3d1dff55cb1881cd2abef6bd136d9e051d8318a9" => :catalina
    sha256 "a10345d4b2edbecaedf57600101130e74d61c0bea18a9a8fb3eb5d07de32b5ee" => :mojave
    sha256 "2e91d4f0ad08292b172485246c853214d930f32ff3980fbaf5021522efa4493b" => :high_sierra
  end

  depends_on "gradle" => :build
  depends_on "openjdk"

  def install
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
