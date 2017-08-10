class Chunkwm < Formula
  desc "Tiling window manager for macOS based on plugin architecture"
  homepage "https://github.com/koekeishiya/chunkwm"
  url "https://github.com/koekeishiya/chunkwm/archive/v0.2.28.tar.gz"
  sha256 "917c6aa09521ff4b7463f731192eea6be6313f0fa4e585f63f85603d0993cf92"

  option "without-tiling", "Do not build tiling plugin."
  option "without-ffm", "Do not build focus-follow-mouse plugin."
  option "without-border", "Do not build border plugin."
  option "with-transparency", "Build transparency plugin."

  def install
    # install chunkwm
    system "make", "install"
    inreplace "#{buildpath}/examples/chunkwmrc", "~/.chunkwm_plugins", "$(brew --prefix chunkwm)/share/plugins"
    bin.install "#{buildpath}/bin/chunkwm"
    (pkgshare/"examples").install "#{buildpath}/examples/chunkwmrc"

    # install chunkc
    system "make", "--directory", "src/chunkc"
    bin.install "#{buildpath}/src/chunkc/bin/chunkc"

    # install tiling plugin
    if build.with? "tiling"
      system "make", "install", "--directory", "src/plugins/tiling"
      (pkgshare/"plugins").install "#{buildpath}/plugins/tiling.so"
      (pkgshare/"examples").install "#{buildpath}/src/plugins/tiling/examples/khdrc"
    end

    # install ffm plugin
    if build.with? "ffm"
      system "make", "install", "--directory", "src/plugins/ffm"
      (pkgshare/"plugins").install "#{buildpath}/plugins/ffm.so"
    end

    # install border plugin
    if build.with? "border"
      system "make", "install", "--directory", "src/plugins/border"
      (pkgshare/"plugins").install "#{buildpath}/plugins/border.so"
    end

    # install transparency plugin
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

    For keybindings install and configure https://github.com/koekeishiya/khd.
    chunkwm provides an example khd configuration file for easier setup:
      cp #{opt_pkgshare}/examples/khdrc ~/.khdrc
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
        <string>/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin</string>
        </dict>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
        <key>StandardOutPath</key>
        <string>#{var}/log/chunkwm/chunkwm.out</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/chunkwm/chunkwm.err</string>
    </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/chunkwm", "--version"
  end
end
