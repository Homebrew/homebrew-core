class GhosttyTerminal < Formula
  desc "Terminal emulator that uses platform-native UI and GPU acceleration"
  homepage "https://ghostty.org/"
  # Unlike GitHub's tag archive, this tarball ships compiled GTK resources,
  # so blueprint-compiler is not needed. See PACKAGING.md.
  url "https://release.files.ghostty.org/1.4.0/ghostty-1.4.0.tar.gz"
  sha256 "cb188ac6c3a8278d5fd7bfef15d8c017104c87f638b5560eb38024a71ae0f005"
  license "MIT"
  head "https://github.com/ghostty-org/ghostty/releases/download/tip/ghostty-source.tar.gz"

  livecheck do
    url "https://release.files.ghostty.org/appcast.xml"
    strategy :sparkle, &:short_version
  end

  depends_on "gettext" => :build
  depends_on "ncurses" => :build
  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "zig" => :build

  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "gtk4-layer-shell"
  depends_on "harfbuzz"
  depends_on "libadwaita"
  depends_on "libx11"
  depends_on :linux # building on macOS creates a .app; the `ghostty` cask provides that
  depends_on "mesa"
  depends_on "oniguruma"
  depends_on "wayland"

  deny_network_access!

  def fetch
    system "zig", "build", "--fetch=all"
  end

  def install
    args = %W[
      --system #{buildpath}/zig-pkg
      -Dinstalled-exe-path=#{opt_bin}/ghostty
    ]
    args << "-Dversion-string=#{version}" if build.stable?
    system "zig", "build", *args, *std_zig_args

    # systemd finds user units in $XDG_DATA_DIRS/systemd/user, but `--system` installs them
    # to <prefix>/lib/systemd/user, which is searched only if <prefix> is /usr or /usr/local.
    # https://www.freedesktop.org/software/systemd/man/latest/systemd.unit.html#User%20Unit%20Search%20Path
    share.install lib/"systemd"

    # Ghostty 1.4.0 bundles a pre-release libghostty-vt that it doesn't link.
    # Remove in the next release: https://github.com/ghostty-org/ghostty/pull/15069
    if build.stable?
      rm lib.glob("libghostty-vt*")
      rm share.glob("pkgconfig/libghostty-vt*.pc")
      rm_r include/"ghostty"
    end
  end

  def caveats
    <<~EOS
      Ghostty's D-Bus activation and systemd user services require $XDG_DATA_DIRS
      to contain "#{HOMEBREW_PREFIX}/share".
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ghostty --version") if build.stable?

    assert_match "font-size", shell_output("#{bin}/ghostty +show-config --default")

    (testpath/"config").write "font-size = not-a-number\n"
    output = shell_output("#{bin}/ghostty +validate-config --config-file=#{testpath}/config", 1)
    assert_match "font-size", output

    assert_path_exists share/"dbus-1/services/com.mitchellh.ghostty.service"
    assert_path_exists share/"systemd/user/app-com.mitchellh.ghostty.service"
    assert_path_exists share/"terminfo/x/xterm-ghostty"
  end
end
