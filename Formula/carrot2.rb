class Carrot2 < Formula
  desc "Search results clustering engine"
  homepage "https://project.carrot2.org"
  url "https://github.com/carrot2/carrot2/releases/download/release%2F3.16.3/carrot2-dcs-3.16.3.zip"
  sha256 "653221f8d11a5712f6889555110ffb4b8eab9ba1ac042cb35a5a16f4531e5ee1"

  bottle :unneeded

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    bin.install libexec/"dcs.sh" => "carrot2"
    inreplace bin/"carrot2", "java", "cd #{libexec} && exec '#{Formula["openjdk"].opt_bin}/java'"
  end

  plist_options :manual => "carrot2"

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
    cp_r Dir["#{prefix}/*"], testpath
    inreplace testpath/"bin/carrot2", "cd #{libexec}", "cd #{testpath}/libexec"
    begin
      pid = fork { exec testpath/"bin/carrot2" }
      sleep 5
      assert_match /data mining/m,
        shell_output("curl -s -F dcs.c2stream=@#{libexec}/examples/shared/data-mining.xml " \
                     "http://localhost:8080/dcs/rest")
    ensure
      Process.kill "INT", pid
    end
  end
end
