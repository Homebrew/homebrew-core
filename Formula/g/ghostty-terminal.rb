class GhosttyTerminal < Formula
  desc "Terminal emulator that uses platform-native UI and GPU acceleration"
  homepage "https://ghostty.org/"
  # Upstream's source tarball rather than the GitHub tag archive: it ships
  # pre-generated files so blueprint-compiler is not needed. See PACKAGING.md.
  url "https://release.files.ghostty.org/1.3.1/ghostty-1.3.1.tar.gz"
  sha256 "3349d25600ffbda281197a18314f7d18791969cffe9474f0ff16a45a9ebfccdb"
  license "MIT"

  livecheck do
    url "https://github.com/ghostty-org/ghostty.git"
    strategy :git
  end

  depends_on "gettext" => :build
  depends_on "ncurses" => :build
  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "zig@0.15" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "harfbuzz"
  depends_on "libadwaita"
  depends_on "libx11"
  # The macOS app is native SwiftUI and is distributed as the `ghostty` cask.
  depends_on :linux
  depends_on "oniguruma"
  depends_on "wayland"

  # Ghostty compiles its own, newer terminfo entry; ncurses ships one too.
  link_overwrite "share/terminfo/g/ghostty"

  deny_network_access!

  def fetch
    # `zig build --fetch` misses transitive dependencies, so use the URL list
    # upstream ships for packagers, as nix/build-support/fetch-zig-cache.sh does.
    # https://github.com/ziglang/zig/issues/20976
    (buildpath/"build.zig.zon.txt").each_line(chomp: true) do |url|
      system "zig", "fetch", url
    end
  end

  def install
    # Zig's own clang bypasses Homebrew's compiler shims, so the bundled
    # gtk4-layer-shell cannot find the Wayland headers without this.
    ENV.prepend_path "CPATH", HOMEBREW_PREFIX/"include"

    # `--system` is upstream's packaging mode: it forbids fetching and defaults
    # to system libraries. gtk4-layer-shell is not in Homebrew, so build the
    # bundled copy. See PACKAGING.md.
    system "zig", "build", *std_zig_args,
           "--system", "#{ENV.fetch("ZIG_GLOBAL_CACHE_DIR")}/p",
           "-Dversion-string=#{version}",
           "-fno-sys=gtk4-layer-shell"

    # Upstream writes the build prefix into these, which breaks on upgrade.
    inreplace share.glob("{applications/*.desktop,dbus-1/services/*.service,systemd/user/*.service}"),
              prefix, opt_prefix
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
    assert_match "Dracula", shell_output("#{bin}/ghostty +list-themes --plain")

    (testpath/"config").write "font-size = not-a-number\n"
    output = shell_output("#{bin}/ghostty +validate-config --config-file=#{testpath}/config", 1)
    assert_match "font-size", output

    assert_path_exists share/"terminfo/g/ghostty"
  end
end
