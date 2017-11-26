class Browserpass < Formula
  desc "Native component for Chrome & Firefox password management add-on"
  homepage "https://github.com/dannyvankooten/browserpass"
  url "https://github.com/dannyvankooten/browserpass/releases/download/2.0.8/browserpass-src.tar.gz"
  version "2.0.8"
  sha256 "5df921f0cfb3ebb0b4c867af08bf69f5cfef30d16101e35fba4c0ce3a558bb51"

  depends_on "go" => :build
  depends_on "gnupg" => :run
  depends_on "pinentry-mac" => :run

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/dannyvankooten/browserpass").install buildpath.children
    cd "src/github.com/dannyvankooten/browserpass" do
      system "make", "browserpass-darwinx64"
      mkdir "out"
      mkdir "out/bin"
      mkdir "out/share"
      cp "browserpass-darwinx64", "out/bin/browserpass"
      cp "install.sh", "out/bin/browserpass-setup"
      cp "firefox/host.json", "out/share/firefox-host.json"
      cp "chrome/host.json", "out/share/chrome-host.json"
      cp "chrome/policy.json", "out/share/chrome-policy.json"
      dir = csh_quote(HOMEBREW_PREFIX)
      inreplace "out/bin/browserpass-setup", /^(BIN_DIR=).*$/, "\\1\"#{dir}/bin\""
      inreplace "out/bin/browserpass-setup", /^(JSON_DIR=).*$/, "\\1\"#{dir}/share/browserpass\""
      bin.install Dir["out/bin/*"]
      pkgshare.install Dir["out/share/*"]
      ohai "#{Tty.magenta}** To complete installation of browserpass, do the following:#{Tty.reset}"
      puts "(1) Install the browserpass-ce add-on in your browser."
      puts "    - Chrome: https://chrome.google.com/webstore/detail/browserpass-ce/naepdomgkenhinolocfifgehidddafch"
      puts "    - Firefox: https://addons.mozilla.org/en-US/firefox/addon/browserpass-ce/"
      puts "(2) Run `browserpass-setup` to install browser-specific manifest files."
      ohai "#{Tty.magenta}** The add-on will not work otherwise!#{Tty.reset}"
    end
  end

  test do
    mkdir "#{ENV["HOME"]}/.password-store"
    json = { :action => "search", :domain => "test" }
    msg = JSON.generate(json)
    Open3.popen3("#{bin}/browserpass") do |stdin, stdout, _|
      stdin.write([msg.bytesize].pack("L"))
      stdin.write(msg)
      stdin.close
      len = stdout.read(4).unpack("L")[0]
      result = JSON.parse(stdout.read(len))
      assert_equal(result, [])
    end
  end
end
