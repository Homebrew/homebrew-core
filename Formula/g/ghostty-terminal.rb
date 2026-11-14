class GhosttyTerminal < Formula
  desc "Terminal emulator that uses platform-native UI and GPU acceleration"
  homepage "https://ghostty.org/"
  # Unlike GitHub's tag archive, this tarball ships compiled GTK resources,
  # so blueprint-compiler is not needed. See PACKAGING.md.
  url "https://release.files.ghostty.org/1.4.0/ghostty-1.4.0.tar.gz"
  sha256 "cb188ac6c3a8278d5fd7bfef15d8c017104c87f638b5560eb38024a71ae0f005"
  license "MIT"

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
  depends_on "harfbuzz"
  depends_on "libadwaita"
  depends_on "libx11"
  # On macOS the build system produces a .app bundle.
  depends_on :linux
  depends_on "oniguruma"
  depends_on "wayland"

  # Ghostty compiles its own, newer terminfo entry; ncurses ships one too.
  link_overwrite "share/terminfo/g/ghostty"

  deny_network_access!

  def fetch
    system "zig", "build", "--fetch=all"
  end

  def install
    # gtk4-layer-shell isn't in Homebrew, so build the bundled copy, which
    # needs Wayland's headers on Zig's include path.
    ENV.prepend_path "CPATH", formula_opt_include("wayland")
    system "zig", "build", *std_zig_args,
           "--system", "#{ENV.fetch("ZIG_GLOBAL_CACHE_DIR")}/p",
           "-Dversion-string=#{version}",
           "-Dinstalled-exe-path=#{opt_bin}/ghostty",
           "-fno-sys=gtk4-layer-shell"

    # `--system` puts the systemd user unit in `lib`, which systemd never
    # searches under Homebrew's prefix. `share` can be found via $XDG_DATA_DIRS.
    (share/"systemd").install lib/"systemd/user"
  end

  def caveats
    <<~EOS
      Ghostty's D-Bus activation and systemd user service require $XDG_DATA_DIRS
      to contain "#{HOMEBREW_PREFIX}/share".
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ghostty --version")
    assert_match "font-size", shell_output("#{bin}/ghostty +show-config --default")

    (testpath/"config").write "font-size = not-a-number\n"
    output = shell_output("#{bin}/ghostty +validate-config --config-file=#{testpath}/config", 1)
    assert_match "font-size", output

    assert_path_exists share/"terminfo/g/ghostty"
  end
end
