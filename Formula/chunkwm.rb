class Chunkwm < Formula
  desc "Tiling window manager for macOS based on plugin architecture"
  homepage "https://github.com/koekeishiya/chunkwm"
  url "https://github.com/koekeishiya/chunkwm/archive/v0.2.29.tar.gz"
  sha256 "6f5913476a5e0e7afab59b79061be4952ab575f9d9d06ed91de6297bd169bd38"
  head "https://github.com/koekeishiya/chunkwm.git"

  option "without-tiling", "Do not build tiling plugin."
  option "without-ffm", "Do not build focus-follow-mouse plugin."
  option "without-border", "Do not build border plugin."
  option "with-transparency", "Build transparency plugin."

  depends_on :macos => :el_capitan

  def install
    system "make", "install"
    inreplace "#{buildpath}/examples/chunkwmrc", "~/.chunkwm_plugins", "#{opt_pkgshare}/plugins"
    bin.install "#{buildpath}/bin/chunkwm"
    (pkgshare/"examples").install "#{buildpath}/examples/chunkwmrc"

    system "make", "--directory", "src/chunkc"
    bin.install "#{buildpath}/src/chunkc/bin/chunkc"

    if build.with? "tiling"
      system "make", "install", "--directory", "src/plugins/tiling"
      (pkgshare/"plugins").install "#{buildpath}/plugins/tiling.so"
      (pkgshare/"examples").install "#{buildpath}/src/plugins/tiling/examples/khdrc"
    end

    if build.with? "ffm"
      system "make", "install", "--directory", "src/plugins/ffm"
      (pkgshare/"plugins").install "#{buildpath}/plugins/ffm.so"
    end

    if build.with? "border"
      system "make", "install", "--directory", "src/plugins/border"
      (pkgshare/"plugins").install "#{buildpath}/plugins/border.so"
    end

    if build.with? "transparency"
      system "make", "install", "--directory", "src/plugins/transparency"
      (pkgshare/"plugins").install "#{buildpath}/plugins/transparency.so"
    end
  end

  def caveats; <<-EOS.undent
    Copy the example configuration into your home directory:
      cp #{opt_pkgshare}/examples/chunkwmrc ~/.chunkwmrc

    Opening chunkwm will prompt for Accessibility API permissions. After access
    has been granted, the application must be restarted.
      brew services restart chunkwm

    This has to be done after every update to chunkwm, unless you codesign the
    binary with self-signed certificate before restarting
      Create code signing certificate named "chunkwm-cert" using Keychain Access.app
      codesign -fs "chunkwm-cert" #{opt_bin}/chunkwm
    EOS
  end

  plist_options :manual => "chunkwm"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/chunkwm</string>
      </array>
      <key>EnvironmentVariables</key>
      <dict>
        <key>PATH</key>
        <string>#{HOMEBREW_PREFIX}/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
      </dict>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
      <key>StandardOutPath</key>
      <string>#{var}/log/chunkwm.log</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/chunkwm.log</string>
    </dict>
    </plist>
  EOS
  end

  test do
    assert_match "chunkwm #{version}", shell_output("#{bin}/chunkwm --version")
  end
end
