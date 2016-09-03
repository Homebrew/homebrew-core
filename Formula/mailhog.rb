require "language/go"

class Mailhog < Formula
  desc "Web and API based SMTP testing tool"
  homepage "https://github.com/mailhog/MailHog"
  url "https://github.com/mailhog/MailHog/archive/v0.2.0.tar.gz"
  sha256 "e7aebdc9295aa3a4a15198b921e76ec9b1a490d2f3e67d4670b94d816d070f37"

  head "https://github.com/mailhog/MailHog.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "29ecb43871179f654a34de212d0d91fee1f429ad166a1cfd247292d3b1b1cc3d" => :el_capitan
    sha256 "8e2d50b96d41c17ecf2b3f82469e9cc09d46d1022ac657a7ade32fd7d92d5116" => :yosemite
    sha256 "7966918bcc33de8e4e9d08d4e5c96fb482f43b1f4c53199f00a5f88633e2e7ed" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/gorilla/context" do
    url "https://github.com/gorilla/context.git"
  end

  go_resource "github.com/gorilla/mux" do
    url "https://github.com/gorilla/mux.git"
  end

  go_resource "github.com/gorilla/pat" do
    url "https://github.com/gorilla/pat.git"
  end

  go_resource "github.com/gorilla/websocket" do
    url "https://github.com/gorilla/websocket.git"
  end

  go_resource "github.com/ian-kent/envconf" do
    url "https://github.com/ian-kent/envconf.git"
  end

  go_resource "github.com/ian-kent/go-log" do
    url "https://github.com/ian-kent/go-log.git"
  end

  go_resource "github.com/ian-kent/goose" do
    url "https://github.com/ian-kent/goose.git"
  end

  go_resource "github.com/ian-kent/linkio" do
    url "https://github.com/ian-kent/linkio.git"
  end

  go_resource "github.com/mailhog/data" do
    url "https://github.com/mailhog/data.git"
  end

  go_resource "github.com/mailhog/http" do
    url "https://github.com/mailhog/http.git"
  end

  go_resource "github.com/mailhog/mhsendmail" do
    url "https://github.com/mailhog/mhsendmail.git"
  end

  go_resource "github.com/mailhog/smtp" do
    url "https://github.com/mailhog/smtp.git"
  end

  go_resource "github.com/mailhog/storage" do
    url "https://github.com/mailhog/storage.git"
  end

  go_resource "github.com/mailhog/MailHog-Server" do
    url "https://github.com/mailhog/MailHog-Server.git"
  end

  go_resource "github.com/mailhog/MailHog-UI" do
    url "https://github.com/mailhog/MailHog-UI.git"
  end

  go_resource "github.com/mailhog/MailHog" do
    url "https://github.com/mailhog/MailHog.git"
  end

  go_resource "github.com/spf13/pflag" do
    url "https://github.com/spf13/pflag.git"
  end

  go_resource "github.com/t-k/fluent-logger-golang" do
    url "https://github.com/t-k/fluent-logger-golang.git"
  end

  go_resource "github.com/tinylib/msgp" do
    url "https://github.com/tinylib/msgp.git"
  end

  go_resource "golang.org/x/crypto" do
    url "https://github.com/golang/crypto.git"
  end

  go_resource "github.com/philhofer/fwd" do
    url "https://github.com/philhofer/fwd.git"
  end

  go_resource "gopkg.in/mgo.v2" do
    url "https://github.com/go-mgo/mgo.git",
      :branch => "v2"
  end

  def install
    (buildpath/"src/github.com/mailhog/").mkpath
    ln_s buildpath, "#{buildpath}/src/github.com/mailhog/MailHog"

    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", "MailHog"
    bin.install "MailHog"
  end

  plist_options :manual => "MailHog"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>KeepAlive</key>
      <true/>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/MailHog</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>StandardErrorPath</key>
      <string>#{var}/log/mailhog.log</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/mailhog.log</string>
    </dict>
    </plist>
    EOS
  end

  test do
    pid = fork do
      exec "#{bin}/MailHog"
    end
    sleep 2

    begin
      output = shell_output("curl -s http://localhost:8025")
      assert_match %r{<title>MailHog</title>}, output
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
