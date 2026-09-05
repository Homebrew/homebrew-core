class Mailcatcher < Formula
  desc "Catches mail and serves it through a dream"
  homepage "https://mailcatcher.me"
  url "https://github.com/sj26/mailcatcher/archive/refs/tags/v0.11.0.tar.gz"
  sha256 "d8b704a7699bca68ac89f99ca40234120099683d58eb0646d1ab16bf06c7c593"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "bc09e2f849b5ad9591fc1d7f40629130beef8471daae2f3f4989fbfc85d3901d"
    sha256 cellar: :any, arm64_sequoia: "83084196397ee32f86cb8357400871ef5aa6b4b2d6831a264449a3740e0eff0f"
    sha256 cellar: :any, arm64_sonoma:  "20dfdecca185bc4e67828f44d974a69d7089e093d68507cede4a91951087b605"
    sha256 cellar: :any, arm64_linux:   "5df7c7dce299f185ed29e8ff5213ac668ba5adb4fbb77b8198d491060d8d9a30"
    sha256 cellar: :any, x86_64_linux:  "839ea0b9b2138b2d1d64e5c371ee797ee5ca5f0df7b3be97a034c4e50637e794"
  end

  depends_on "pkgconf" => :build
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "ruby"

  uses_from_macos "libedit"
  uses_from_macos "libffi"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  resource "rack" do
    url "https://rubygems.org/downloads/rack-3.2.7.gem"
    sha256 "93e13e1c24f93556671d85d2d79fa228c3485815c50d7e2f265b5330c6528fb7"
  end

  resource "eventmachine" do
    url "https://rubygems.org/downloads/eventmachine-1.2.7.gem"
    sha256 "994016e42aa041477ba9cff45cbe50de2047f25dd418eba003e84f0d16560972"
  end

  resource "daemons" do
    url "https://rubygems.org/downloads/daemons-1.4.1.gem"
    sha256 "8fc76d76faec669feb5e455d72f35bd4c46dc6735e28c420afb822fac1fa9a1d"
  end

  resource "logger" do
    url "https://rubygems.org/downloads/logger-1.7.0.gem"
    sha256 "196edec7cc44b66cfb40f9755ce11b392f21f7967696af15d274dde7edff0203"
  end

  resource "thin" do
    url "https://rubygems.org/downloads/thin-2.0.1.gem"
    sha256 "5bbde5648377f5c3864b5da7cd89a23b5c2d8d8bb9435719f6db49644bcdade9"
  end

  # needed for sqlite
  resource "mini_portile2" do
    url "https://rubygems.org/downloads/mini_portile2-2.8.9.gem"
    sha256 "0cd7c7f824e010c072e33f68bc02d85a00aeb6fce05bb4819c03dfd3c140c289"
  end

  resource "sqlite" do
    url "https://rubygems.org/downloads/sqlite3-2.9.6.gem"
    sha256 "956fe606956420d04ac7157d3ace620c8caba2135b2e05c76e483493da24d08e"
  end

  resource "tilt" do
    url "https://rubygems.org/downloads/tilt-2.9.0.gem"
    sha256 "da5735d0280bba96e9a91041bb14aee435ccad5c17b0fa519249ae543d9aa3a5"
  end

  resource "base64" do
    url "https://rubygems.org/downloads/base64-0.3.0.gem"
    sha256 "27337aeabad6ffae05c265c450490628ef3ebd4b67be58257393227588f5a97b"
  end

  resource "rack-protection" do
    url "https://rubygems.org/downloads/rack-protection-4.2.1.gem"
    sha256 "cf6e2842df8c55f5e4d1a4be015e603e19e9bc3a7178bae58949ccbb58558bac"
  end

  resource "mustermann" do
    url "https://rubygems.org/downloads/mustermann-3.1.1.gem"
    sha256 "4c6170c7234d5499c345562ba7c7dfe73e1754286dcc1abb053064d66a127198"
  end

  resource "rack-session" do
    url "https://rubygems.org/downloads/rack-session-2.1.2.gem"
    sha256 "595434f8c0c3473ae7d7ac56ecda6cc6dfd9d37c0b2b5255330aa1576967ffe8"
  end

  resource "sinatra" do
    url "https://rubygems.org/downloads/sinatra-4.2.1.gem"
    sha256 "b7aeb9b11d046b552972ade834f1f9be98b185fa8444480688e3627625377080"
  end

  resource "timeout" do
    url "https://rubygems.org/downloads/timeout-0.6.1.gem"
    sha256 "78f57368a7e7bbadec56971f78a3f5ecbcfb59b7fcbb0a3ed6ddc08a5094accb"
  end

  resource "net-protocol" do
    url "https://rubygems.org/downloads/net-protocol-0.3.0.gem"
    sha256 "ba310c3d4f1cad46bb1ab20336b06669b1ff8f7c568d9cb9342b32a718547472"
  end

  resource "net-smtp" do
    url "https://rubygems.org/downloads/net-smtp-0.5.1.gem"
    sha256 "ed96a0af63c524fceb4b29b0d352195c30d82dd916a42f03c62a3a70e5b70736"
  end

  resource "net-pop" do
    url "https://rubygems.org/downloads/net-pop-0.1.2.gem"
    sha256 "848b4e982013c15b2f0382792268763b748cce91c9e91e36b0f27ed26420dff3"
  end

  resource "date" do
    url "https://rubygems.org/downloads/date-3.5.1.gem"
    sha256 "750d06384d7b9c15d562c76291407d89e368dda4d4fff957eb94962d325a0dc0"
  end

  resource "net-imap" do
    url "https://rubygems.org/downloads/net-imap-0.6.6.gem"
    sha256 "96aa4ee50df3060203e649efc341f53480b791d49e150f2fdebf68beb141a8df"
  end

  resource "mini_mime" do
    url "https://rubygems.org/downloads/mini_mime-1.1.5.gem"
    sha256 "8681b7e2e4215f2a159f9400b5816d85e9d8c6c6b491e96a12797e798f8bccef"
  end

  resource "mail" do
    url "https://rubygems.org/downloads/mail-2.9.1.gem"
    sha256 "06574eca475253d6c18145dd70af80d0eb970182d55053497c5f4d797ea160e8"
  end

  resource "websocket-extensions" do
    url "https://rubygems.org/downloads/websocket-extensions-0.1.5.gem"
    sha256 "1c6ba63092cda343eb53fc657110c71c754c56484aad42578495227d717a8241"
  end

  resource "websocket-driver" do
    url "https://rubygems.org/downloads/websocket-driver-0.8.2.gem"
    sha256 "97c556b019bf3410b4961002ac501621e9322d3f8a7bc02161a09301cc4c4146"
  end

  resource "faye-websocket" do
    url "https://rubygems.org/downloads/faye-websocket-0.12.0.gem"
    sha256 "ad9f7dfcd0306d0a13baeee450729657661129af15bb5f38716c242484ab42e1"
  end

  def install
    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.fetch
      args = [r.cached_download, "--ignore-dependencies", "--no-document", "--install-dir", libexec]
      args += ["--", "--enable-system-libraries"] if r.name == "sqlite"
      system "gem", "install", *args
    end

    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "--ignore-dependencies", "#{name}-#{version}.gem"
    bin.install libexec/"bin"/name, libexec/"bin/catchmail"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  service do
    run [opt_bin/"mailcatcher", "-f"]
    log_path var/"log/mailcatcher.log"
    error_log_path var/"log/mailcatcher.log"
    keep_alive true
  end

  test do
    smtp_port = free_port
    http_port = free_port
    system bin/"mailcatcher", "--smtp-port", smtp_port.to_s, "--http-port", http_port.to_s

    TCPSocket.open("localhost", smtp_port) do |sock|
      assert_match "220 ", sock.gets
      sock.puts "HELO example.org"
      assert_match "250 ", sock.gets
      sock.puts "MAIL FROM:<bob@example.org>"
      assert_match "250 ", sock.gets
      sock.puts "RCPT TO:<alice@example.com>"
      assert_match "250 ", sock.gets
      sock.puts "DATA"
      assert_match "354 ", sock.gets
      sock.puts <<~TEXT
        From: Bob Example <bob@example.org>
        To: Alice Example <alice@example.com>
        Date: Tue, 15 Jan 2008 16:02:43 -0500
        Subject: Test message

        Hello Alice.
        .
      TEXT
      assert_match "250 ", sock.gets
      sock.puts "QUIT"
      assert_match "221 ", sock.gets
    ensure
      sock.close
    end

    assert_match "bob@example.org", shell_output("curl --silent http://localhost:#{http_port}/messages")
    assert_equal "Hello Alice.", shell_output("curl --silent http://localhost:#{http_port}/messages/1.plain").strip
    javascript = shell_output("curl --silent --fail http://localhost:#{http_port}/assets/mailcatcher.js")
    assert_match "class MailCatcherApp", javascript
    system "curl", "--silent", "-X", "DELETE", "http://localhost:#{http_port}/"
  end
end
