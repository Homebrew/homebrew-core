class Consul < Formula
  desc "Tool for service discovery, monitoring and configuration"
  homepage "https://www.consul.io"
  url "https://github.com/hashicorp/consul.git",
      :tag => "v0.7.0",
      :revision => "a189091a3530051285c12c726ca28ea55e015336"

  head "https://github.com/hashicorp/consul.git",
       :shallow => false

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "f9dc303e3da2f509bb9aeacdd34a3f93deb474c3201089623911c260cab44181" => :el_capitan
    sha256 "f3489f7156757dd0a896dbb9d58436c7e84d6d4703804fec89e737809f2220d8" => :yosemite
    sha256 "02c98b52b0eb41979f77f366b8a7bebc1f0b391c37b1f281ddba9fb3484f1b58" => :mavericks
  end

  option "with-web-ui", "Installs the consul web ui"

  depends_on "go" => :build

  def install
    contents = Dir["{*,.git,.gitignore}"]
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/hashicorp/consul").install contents

    ENV["GOPATH"] = gopath
    ENV.prepend_create_path "PATH", gopath/"bin"

    cd gopath/"src/github.com/hashicorp/consul" do
      system "make"
      bin.install "bin/consul"
      zsh_completion.install "contrib/zsh-completion/_consul"
    end

    # install web-ui to package share folder.
    (pkgshare/"web-ui").install resource("web-ui") if build.with? "web-ui"
  end

  def caveats; <<-EOS.undent
    If consul was built with --with-web-ui, you can activate the UI by running
    consul with `-ui-dir #{pkgshare}/web-ui`.
    EOS
  end

  plist_options :manual => "consul agent -dev -advertise 127.0.0.1"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <dict>
          <key>SuccessfulExit</key>
          <false/>
        </dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/consul</string>
          <string>agent</string>
          <string>-dev</string>
          <string>-advertise</string>
          <string>127.0.0.1</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/consul.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/consul.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    fork do
      exec "#{bin}/consul", "agent", "-data-dir", "."
    end
    sleep 3
    system "#{bin}/consul", "leave"
  end
end
