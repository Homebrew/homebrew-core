class Pulseaudio < Formula
  desc "Sound system for POSIX OSes"
  homepage "https://wiki.freedesktop.org/www/Software/PulseAudio/"
  url "https://www.freedesktop.org/software/pulseaudio/releases/pulseaudio-14.1.tar.xz"
  sha256 "b0bcca2a45e4fe1f73c7709dcf75a17dd5235688d5d150069e765dda4884b837"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later", "BSD-3-Clause"]

  # The regex here avoids x.99 releases, as they're pre-release versions.
  livecheck do
    url :stable
    regex(/href=["']?pulseaudio[._-]v?((?!\d+\.9\d+)\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 "36f025d67efa9bc8198e4810dfc58b584d28f7980d4a98a3c2310f84caf7b773" => :big_sur
    sha256 "b395d9b2f2c5a89971b5fa65abeb9c7a3469f4572a496b554eacbaaff09a6586" => :arm64_big_sur
    sha256 "fc7ff97eaf91b6bcfeeb391b6c885c2fd9c6d3843ab668d9e85a68d7bb55f92d" => :catalina
    sha256 "78718069edbad1c576f4abf5c6fa2e6945e08699b006863dc3e94e27990f044c" => :mojave
  end

  head do
    url "https://gitlab.freedesktop.org/pulseaudio/pulseaudio.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "gettext" => :build
    depends_on "intltool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "json-c"
  depends_on "libsndfile"
  depends_on "libsoxr"
  depends_on "libtool"
  depends_on "openssl@1.1"
  depends_on "speexdsp"

  uses_from_macos "perl" => :build
  uses_from_macos "expat"
  uses_from_macos "m4"

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-coreaudio-output
      --disable-neon-opt
      --disable-nls
      --disable-x11
      --with-mac-sysroot=#{MacOS.sdk_path}
      --with-mac-version-min=#{MacOS.version}
    ]

    if build.head?
      # autogen.sh runs bootstrap.sh then ./configure
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  plist_options manual: "pulseaudio"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/pulseaudio</string>
          <string>--exit-idle-time=-1</string>
          <string>--verbose</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
        <key>StandardErrorPath</key>
        <string>#{var}/log/#{name}.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/#{name}.log</string>
      </dict>
      </plist>
    EOS
  end

  test do
    assert_match "module-sine", shell_output("#{bin}/pulseaudio --dump-modules")
  end
end
