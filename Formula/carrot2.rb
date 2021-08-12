class Carrot2 < Formula
  desc "Search results clustering engine"
  homepage "https://project.carrot2.org"
  url "https://github.com/carrot2/carrot2.git",
      tag:      "release/4.3.1",
      revision: "5ee1bc852738bce97fe8be355720f5809fb4cdec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "46ec4d892dbe4c93519d0ab6c0dcb567398982bfd8e211985a9a4938351cb40d"
    sha256 cellar: :any_skip_relocation, catalina:     "86d5724dded84fadd2e522cf97350500cbd9f2af46fd59735cb001a69187041d"
    sha256 cellar: :any_skip_relocation, mojave:       "52a22394905c670f35257fd4c428fc1c5919957d8ab5642d8ee068286ca6703c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "66b3d79a8e8e5ef99f385a2b22c392a240cc3be1475d136eca377c4bf802c499"
  end

  # Switch to `gradle` when carrot2 supports Gradle 7+
  depends_on "gradle@6" => :build
  depends_on "openjdk@11"

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
      JAVA_CMD:    "exec '#{Formula["openjdk@11"].opt_bin}/java'",
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
    sleep 20
    assert_match "Lingo", shell_output("curl -s localhost:#{port}/service/list")
  end
end
