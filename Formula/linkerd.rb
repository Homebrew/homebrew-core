class Linkerd < Formula
  desc "Drop-in RPC proxy designed for microservices"
  homepage "http://linkerd.io/"
  url "https://github.com/BuoyantIO/linkerd/releases/download/0.7.5/linkerd-0.7.5.tgz"
  sha256 "6f18f77b6dac019e24ccfb6adec74d6b13430be79af05f504461b39db85ebdca"

  bottle :unneeded
  depends_on java: "1.8+"

  def install
    # Replacing disco folder path
    inreplace "config/linkerd.yaml", "disco", libexec/"disco"

    # Installing and symlinking
    libexec.install "disco", "linkerd-#{version}-exec"
    share.install "docs"
    pkgshare.install "config/linkerd.yaml"
    bin.install_symlink libexec/"linkerd-#{version}-exec" => "linkerd"

    # Configuring etc folder
    mv "config", "linkerd"
    etc.install "linkerd"
    libexec.install_symlink etc/"linkerd" => "config"
  end

  def caveats; <<-EOS.undent
    Data:    #{libexec}/disco
    Docs:    #{share}/docs
    Logs:    #{var}/log/linkerd
    Config:  #{etc}/linkerd
    EOS
  end

  plist_options manual: "linkerd #{HOMEBREW_PREFIX}/etc/linkerd/linkerd.yaml"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>WorkingDirectory</key>
        <string>#{HOMEBREW_PREFIX}</string>
        <key>ProgramArguments</key>
        <array>
            <string>#{opt_bin}/linkerd</string>
            <string>#{etc}/linkerd/linkerd.yaml</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>StandardErrorPath</key>
        <string>#{var}/log/linkerd/linkerd.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/linkerd/linkerd.log</string>
    </dict>
    </plist>
    EOS
  end

  test do
    begin
      system "echo 'It works!' > #{testpath}/index.html"
      system "pushd #{testpath}; python -m SimpleHTTPServer 9999 > #{testpath}/simple-http-server.log 2>&1 &"
      system "linkerd #{pkgshare}/linkerd.yaml > #{testpath}/linkerd.logs 2>&1 &"

      sleep 5

      system "curl -s -H 'Host: web' http://localhost:4140/ > #{testpath}/result_web &"
      system "curl -s -I -H 'Host: foo' http://localhost:4140/ > #{testpath}/result_foo &"

      sleep 2
    ensure
      system "ps -ef | grep -E 'SimpleHTTPServer|linkerd' | grep -v -E 'grep|brew' | awk '{print $2}' | xargs kill -9"
    end

    assert_match /It works!/, IO.read("#{testpath}/result_web")
    assert_match /Bad Gateway/, IO.read("#{testpath}/result_foo")
  end
end
