class Carrot2 < Formula
  desc "Search results clustering engine"
  homepage "https://project.carrot2.org"
  url "https://github.com/carrot2/carrot2/releases/download/release%2F3.15.1/carrot2-dcs-3.15.1.zip"
  sha256 "8aedcc83fc9303a978c722f66739e85ab197034f1617c7c4e2b831fb88d43c25"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    libexec.install Dir["*"]
    bin.install libexec/"dcs.sh" => "carrot2"
    inreplace bin/"carrot2", "java", "cd #{libexec} && exec java"
  end

  plist_options :manual => "carrot2"

  def plist; <<-EOS.undent
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
    cp_r Dir["#{prefix}/*"], testpath
    inreplace testpath/"bin/carrot2", "cd #{libexec}", "cd #{testpath}/libexec"
    begin
      pid = fork { exec testpath/"bin/carrot2" }
      sleep 5
      output = shell_output("curl -s -F dcs.c2stream=@#{libexec}/examples/shared/data-mining.xml http://localhost:8080/dcs/rest")
      assert_match /data mining/m, output
    ensure
      Process.kill "INT", pid
    end
  end
end
