class Consul < Formula
  desc "Tool for service discovery, monitoring and configuration"
  homepage "https://www.consul.io"
  url "https://github.com/hashicorp/consul.git",
      :tag => "v0.8.3",
      :revision => "ea2a82b221c3e0a466a4f38ab4e8718ad8c60621"

  head "https://github.com/hashicorp/consul.git",
       :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "122964923de32226e771d653b6be901ca99ce06e31a21706da10e658813d4d17" => :sierra
    sha256 "e4aa0dfcf86522873fb0fbad66e53aa2c449aa70838c6a71dc1680c1e610024c" => :el_capitan
    sha256 "fda33a8d80ecedf9eb4d5735573985304817b0c3cedddd500d2fa11abad46b0e" => :yosemite
  end

  option "with-web-ui", "Installs the consul web ui"

  depends_on "go" => :build

  resource "web-ui" do
    url "https://releases.hashicorp.com/consul/0.8.2/consul_0.8.2_web_ui.zip"
    sha256 "81e6da2e679c0235ef42c6f4054045603e12e51850d979cba9c2d4fe06723131"
  end

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
      exec "#{bin}/consul", "agent", "-data-dir", ".", "-server", "-bootstrap"
    end
    sleep 30
    system "#{bin}/consul", "info"
    system "#{bin}/consul", "leave"
  end
end
