class Gitbucket < Formula
  desc "Git platform powered by Scala offering"
  homepage "https://github.com/gitbucket/gitbucket"
  url "https://github.com/gitbucket/gitbucket/releases/download/4.35.2/gitbucket.war"
  sha256 "c7e94c76cb0e73e8488660fee794b3f3366bea2c7d155703bb71e9faedac61b2"
  license "Apache-2.0"

  head do
    url "https://github.com/gitbucket/gitbucket.git"
    depends_on "ant" => :build
  end

  bottle :unneeded

  depends_on "openjdk"

  def install
    if build.head?
      system "ant"
      libexec.install "war/target/gitbucket.war", "."
    else
      libexec.install "gitbucket.war"
    end
  end

  def caveats
    <<~EOS
      Note: When using launchctl the port will be 8080.
    EOS
  end

  plist_options manual: "java -jar #{HOMEBREW_PREFIX}/opt/gitbucket/libexec/gitbucket.war"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>Label</key>
          <string>gitbucket</string>
          <key>ProgramArguments</key>
          <array>
            <string>#{Formula["openjdk"].opt_bin}/java</string>
            <string>-Dmail.smtp.starttls.enable=true</string>
            <string>-jar</string>
            <string>#{opt_libexec}/gitbucket.war</string>
            <string>--host=127.0.0.1</string>
            <string>--port=8080</string>
          </array>
          <key>RunAtLoad</key>
         <true/>
        </dict>
      </plist>
    EOS
  end

  test do
    java = Formula["openjdk"].opt_bin/"java"
    fork do
      exec "'#{java}' -jar #{libexec}/gitbucket.war --port=#{free_port} > output"
    end
    sleep 12
    File.read("output") !~ /Exception/
  end
end
