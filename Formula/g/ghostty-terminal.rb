class GhosttyTerminal < Formula
  desc "Terminal emulator that uses platform-native UI and GPU acceleration"
  homepage "https://ghostty.org"
  # Upstream's own source tarball, not the GitHub tag archive: it ships the
  # pre-generated GResource and frame data, so blueprint-compiler and
  # glib-compile-resources aren't needed at build time.
  url "https://release.files.ghostty.org/1.3.1/ghostty-1.3.1.tar.gz"
  sha256 "3349d25600ffbda281197a18314f7d18791969cffe9474f0ff16a45a9ebfccdb"
  license "MIT"

  livecheck do
    url "https://github.com/ghostty-org/ghostty.git"
    strategy :git
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "gettext" => :build
  depends_on "ncurses" => :build
  depends_on "pandoc" => :build
  depends_on "pkgconf" => :build
  depends_on "zig@0.15" => :build
  depends_on "glib"
  depends_on "gtk4"
  depends_on "libadwaita"
  depends_on "libx11"
  # The macOS app is native SwiftUI and is distributed as the `ghostty` cask,
  # which also owns the `ghostty` name.
  depends_on :linux
  depends_on "wayland"

  # Ghostty generates its own, newer terminfo entry from its source.
  link_overwrite "share/terminfo/g/ghostty"

  deny_network_access!

  def fetch
    # `zig build --fetch` misses transitive dependencies, so use the dependency
    # URL list that upstream ships for packagers.
    # https://github.com/ziglang/zig/issues/20976
    (buildpath/"build.zig.zon.txt").each_line(chomp: true) do |url|
      system "zig", "fetch", url
    end
  end

  def install
    # The wuffs tarball upstream pins no longer hashes to the value recorded in
    # `pkg/wuffs/build.zig.zon`; its SHA-256 still matches `build.zig.zon.json`.
    # Remove once upstream repins it (already fixed on `main`).
    # Reported: https://github.com/ghostty-org/ghostty/discussions/14160
    inreplace "pkg/wuffs/build.zig.zon",
              "N-V-__8AAAzZywE3s51XfsLbP9eyEw57ae9swYB9aGB6fCMs",
              "N-V-__8AAEXUywEb8JCSytwiCVUsFb2CwHjOB59jhyRhOhsj"

    # Zig bypasses the compiler shims and its native libc detection only finds
    # glibc's own include directory, which has neither the Wayland nor the
    # Linux kernel headers.
    ENV.prepend_path "CPATH", HOMEBREW_PREFIX/"include"

    # Ghostty defaults to a system gtk4-layer-shell, which Homebrew doesn't
    # package, so build and install the bundled copy instead.
    system "zig", "build", *std_zig_args,
           "-Dversion-string=#{version}",
           "-fno-sys=gtk4-layer-shell"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ghostty --version")

    (testpath/"config").write "font-size = not-a-number\n"
    assert_match "font-size", shell_output("#{bin}/ghostty +validate-config " \
                                           "--config-file=#{testpath}/config", 1)

    assert_path_exists share/"terminfo/g/ghostty"
  end
end
