class Linkerd < Formula
  desc "Drop-in RPC proxy designed for microservices"
  homepage "https://linkerd.io/"
  url "https://github.com/linkerd/linkerd/releases/download/1.3.4/linkerd-1.3.4.tgz"
  sha256 "c3c751c26164e1b134a65351aecfa308a2a8442167a0a950051b3fa5b603e8ed"

  bottle :unneeded

  depends_on :java => "1.8+"

  def install
    inreplace "config/linkerd.yaml", "disco", etc/"linkerd/disco"

    libexec.install "linkerd-#{version}-exec"
    bin.install_symlink libexec/"linkerd-#{version}-exec" => "linkerd"

    pkgshare.mkpath
    cp buildpath/"config/linkerd.yaml", pkgshare/"default.yaml"

    etc.install "config" => "linkerd"
    etc.install "disco" => "linkerd/disco"
    libexec.install_symlink etc/"linkerd" => "config"
    libexec.install_symlink etc/"linkerd/disco" => "disco"

    share.install "docs"
  end

  def post_install
    (var/"log/linkerd").mkpath
  end

  plist_options :manual => "linkerd #{HOMEBREW_PREFIX}/etc/linkerd/linkerd.yaml"

  def plist; <<~EOS
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
    (testpath/"index.html").write "It works!"

    simple_http_pid = fork do
      exec "python -m SimpleHTTPServer 9999"
    end
    linkerd_pid = fork do
      exec "#{bin}/linkerd #{pkgshare}/default.yaml"
    end

    sleep 10

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
