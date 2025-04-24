class Mailcatcher < Formula
  desc "Catches mail and serves it through a dream"
  homepage "https://mailcatcher.me"
  url "https://github.com/sj26/mailcatcher/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "4cd027e22878342d6a002402306d42ada1f34045cc1d7f35b5a7fa37b944326e"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "42f5b6813789c297bfb3f2cf9867cb89c387124336f78f0b2db31a9490ff8e39"
    sha256 cellar: :any,                 arm64_sonoma:  "98688362105e37e7b5642971887ec454fa5953c013c499b7401ec75f1705f6d3"
    sha256 cellar: :any,                 arm64_ventura: "d8947cfeb3b8e095f9e9df810fe9eccb62e1da2e73889fac2e1b60794056655d"
    sha256 cellar: :any,                 sonoma:        "65c435eea0ed3421e911b11a64f8cc73c53070b1ae015dbc2523abe62bc1c06c"
    sha256 cellar: :any,                 ventura:       "aab17598a1e1836e38c145aaae6777516b92b0163b4deece91839d2c790280b2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c166212f22ec358d05746d6ca05518198425233c862a414a5fc34319a226b03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "391be8e92219c2ecdb1a9990be909b52d5d45ca818a82ae02953f291aec5649c"
  end

  depends_on "pkgconf" => :build
  depends_on "libedit"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "ruby"

  uses_from_macos "xz" => :build
  uses_from_macos "libffi"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_linux do
    depends_on "node" => :build
  end

  resource "rack" do
    url "https://rubygems.org/downloads/rack-2.2.13.gem"
    sha256 "ccee101719696a5da12ee9da6fb3b1d20cb329939e089e0e458be6e93667f0fb"
  end

  resource "eventmachine" do
    url "https://rubygems.org/downloads/eventmachine-1.2.7.gem"
    sha256 "994016e42aa041477ba9cff45cbe50de2047f25dd418eba003e84f0d16560972"
  end

  resource "daemons" do
    url "https://rubygems.org/downloads/daemons-1.4.1.gem"
    sha256 "8fc76d76faec669feb5e455d72f35bd4c46dc6735e28c420afb822fac1fa9a1d"
  end

  resource "thin" do
    url "https://rubygems.org/downloads/thin-1.8.2.gem"
    sha256 "1c55251aba5bee7cf6936ea18b048f4d3c74ef810aa5e6906cf6edff0df6e121"
  end

  # needed for sqlite
  resource "mini_portile2" do
    url "https://rubygems.org/downloads/mini_portile2-2.8.8.gem"
    sha256 "8e47136cdac04ce81750bb6c09733b37895bf06962554e4b4056d78168d70a75"
  end

  resource "sqlite3" do
    url "https://rubygems.org/downloads/sqlite3-1.7.3.gem"
    sha256 "fa77f63c709548f46d4e9b6bb45cda52aa3881aa12cc85991132758e8968701c"
  end

  resource "tilt" do
    url "https://rubygems.org/downloads/tilt-2.6.0.gem"
    sha256 "263d748466e0d83e510aa1a2e2281eff547937f0ef06be33d3632721e255f76b"
  end

  resource "base64" do
    url "https://rubygems.org/downloads/base64-0.2.0.gem"
    sha256 "0f25e9b21a02a0cc0cea8ef92b2041035d39350946e8789c562b2d1a3da01507"
  end

  resource "rack-protection" do
    url "https://rubygems.org/downloads/rack-protection-3.2.0.gem"
    sha256 "3c74ba7fc59066453d61af9bcba5b6fe7a9b3dab6f445418d3b391d5ea8efbff"
  end

  resource "ruby2_keywords" do
    url "https://rubygems.org/downloads/ruby2_keywords-0.0.5.gem"
    sha256 "ffd13740c573b7301cf7a2e61fc857b2a8e3d3aff32545d6f8300d8bae10e3ef"
  end

  resource "mustermann" do
    url "https://rubygems.org/downloads/mustermann-3.0.3.gem"
    sha256 "d1f8e9ba2ddaed47150ddf81f6a7ea046826b64c672fbc92d83bce6b70657e88"
  end

  resource "sinatra" do
    url "https://rubygems.org/downloads/sinatra-3.2.0.gem"
    sha256 "6e727f4d034e87067d9aab37f328021d7c16722ffd293ef07b6e968915109807"
  end

  resource "timeout" do
    url "https://rubygems.org/downloads/timeout-0.4.3.gem"
    sha256 "9509f079b2b55fe4236d79633bd75e34c1c1e7e3fb4b56cb5fda61f80a0fe30e"
  end

  resource "net-protocol" do
    url "https://rubygems.org/downloads/net-protocol-0.2.2.gem"
    sha256 "aa73e0cba6a125369de9837b8d8ef82a61849360eba0521900e2c3713aa162a8"
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
    url "https://rubygems.org/downloads/date-3.4.1.gem"
    sha256 "bf268e14ef7158009bfeaec40b5fa3c7271906e88b196d958a89d4b408abe64f"
  end

  resource "net-imap" do
    url "https://rubygems.org/downloads/net-imap-0.5.7.gem"
    sha256 "d5c0247832439b62298c0935ba67d8bc02fdb476d7a3e099d6f75b3daf498b91"
  end

  resource "mini_mime" do
    url "https://rubygems.org/downloads/mini_mime-1.1.5.gem"
    sha256 "8681b7e2e4215f2a159f9400b5816d85e9d8c6c6b491e96a12797e798f8bccef"
  end

  resource "mail" do
    url "https://rubygems.org/downloads/mail-2.8.1.gem"
    sha256 "ec3b9fadcf2b3755c78785cb17bc9a0ca9ee9857108a64b6f5cfc9c0b5bfc9ad"
  end

  resource "websocket-extensions" do
    url "https://rubygems.org/downloads/websocket-extensions-0.1.5.gem"
    sha256 "1c6ba63092cda343eb53fc657110c71c754c56484aad42578495227d717a8241"
  end

  resource "websocket-driver" do
    url "https://rubygems.org/downloads/websocket-driver-0.7.7.gem"
    sha256 "056d99f2cd545712cfb1291650fde7478e4f2661dc1db6a0fa3b966231a146b4"
  end

  resource "faye-websocket" do
    url "https://rubygems.org/downloads/faye-websocket-0.11.3.gem"
    sha256 "109187161939c57032d2bba9e5c45621251d73f806bb608d2d4c3ab2cabeb307"
  end

  # Fixes `LoadError: cannot load such file -- mail_catcher/version (LoadError)`
  patch :DATA

  def install
    if OS.mac? && MacOS.version >= :mojave && MacOS::CLT.installed?
      ENV["SDKROOT"] = ENV["HOMEBREW_SDKROOT"] = MacOS::CLT.sdk_path(MacOS.version)
    end

    ENV["GEM_HOME"] = libexec
    resources.each do |r|
      r.fetch
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end

    system "rake", "assets"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "--ignore-dependencies", "#{name}-#{version}.gem"
    bin.install libexec/"bin"/name, libexec/"bin/catchmail"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])

    # Remove temporary logs that reference Homebrew shims.
    # TODO: See if we can handle this better:
    #       https://github.com/sparklemotion/sqlite3-ruby/discussions/394
    rm_r(libexec/"gems/sqlite3-#{resource("sqlite3").version}/ext/sqlite3/tmp")
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
    assert_match "Content-Type: application/javascript", shell_output("curl --silent -i http://localhost:#{http_port}/assets/mailcatcher.js").strip
    system "curl", "--silent", "-X", "DELETE", "http://localhost:#{http_port}/"
  end
end

__END__
diff --git a/Rakefile b/Rakefile
index 6f1f2b4..1381ec2 100644
--- a/Rakefile
+++ b/Rakefile
@@ -3,6 +3,7 @@
 require "fileutils"
 require "rubygems"

+$LOAD_PATH.unshift File.expand_path("lib", __dir__)
 require "mail_catcher/version"

 # XXX: Would prefer to use Rake::SprocketsTask but can't populate
