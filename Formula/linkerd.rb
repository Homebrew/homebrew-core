class Linkerd < Formula
  desc "Drop-in RPC proxy designed for microservices"
  homepage "http://linkerd.io/"
  url "https://github.com/BuoyantIO/linkerd/releases/download/0.7.5/linkerd-0.7.5.tgz"
  sha256 "6f18f77b6dac019e24ccfb6adec74d6b13430be79af05f504461b39db85ebdca"

  bottle :unneeded
  depends_on java: "1.8+"

  def install
    inreplace "config/linkerd.yaml", "disco", libexec/"disco"

    libexec.install "disco", "linkerd-#{version}-exec"
    bin.install_symlink libexec/"linkerd-#{version}-exec" => "linkerd"

    etc.install "config" => "linkerd"
    libexec.install_symlink etc/"linkerd" => "config"

    share.install "docs"
    pkgshare.mkpath
    cp etc/"linkerd/linkerd.yaml", pkgshare/"default.yaml"
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
    system "echo 'It works!' > #{testpath}/index.html"
    cd testpath

    simple_http_pid = fork do
      exec "python -m SimpleHTTPServer 9999"
    end
    linkerd_pid = fork do
      exec "linkerd #{pkgshare}/default.yaml"
    end

    sleep 5

    begin
      assert_match /It works!/, shell_output("curl -s -H 'Host: web' http://localhost:4140")
      assert_match /Bad Gateway/, shell_output("curl -s -I -H 'Host: foo' http://localhost:4140")
    ensure
      Process.kill("TERM", linkerd_pid)
      Process.wait(linkerd_pid)
      Process.kill("TERM", simple_http_pid)
      Process.wait(simple_http_pid)
    end
  end
end
