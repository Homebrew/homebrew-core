class Dissent < Formula
  desc "GTK4 Discord client in Go"
  homepage "https://github.com/diamondburned/dissent"
  url "https://github.com/diamondburned/dissent/archive/refs/tags/v0.0.50.tar.gz"
  sha256 "b60e7b27b05ec8402b22855009f708355065501628dde5c7c14855aaa3a5d0e1"
  license "GPL-3.0-or-later"
  head "https://github.com/diamondburned/dissent.git", branch: "main"

  bottle do
    manifest_sha256 "07d0a6824a54b7c879bd6743c3aef521968e06f42bdcb1e55338deff1c5ae398"
    sha256 cellar: :any, arm64_golden_gate: "6cebc3028caf7721873117c91c16bc7c498fbb759d9aaa52a1497b81dd7aca16"
    sha256 cellar: :any, arm64_tahoe:       "77125542ff2a01bf7d0748cebff68e8234292183b3c75f090604c1978c408549"
    sha256 cellar: :any, arm64_sequoia:     "972c6f9df51a00e5ea334dccea76307d3eff7f6b7dd142006c025fc5340138b1"
    sha256 cellar: :any, arm64_linux:       "4de591e4ed135e79cd8b3ea0f5ffb1e30a66a7c672735b1ad4b625c9d0a2c406"
    sha256 cellar: :any, x86_64_linux:      "662f912fbb6b31bebf16b893d967512f8322236d0fe979bfeaff945fadb42757"
  end

  depends_on "go" => :build
  depends_on "pkgconf" => :build

  depends_on "cairo"
  depends_on "gdk-pixbuf"
  depends_on "glib"
  depends_on "gobject-introspection"
  depends_on "graphene"
  depends_on "gtk4"
  depends_on "gtksourceview5"
  depends_on "libadwaita"
  depends_on "libcanberra"
  depends_on "libspelling"
  depends_on "pango"
  depends_on "pcre2"

  on_macos do
    depends_on "gettext"
    depends_on "harfbuzz"
  end

  on_linux do
    depends_on "xorg-server" => :test
  end

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    # Workaround to avoid patchelf corruption when cgo is required
    if OS.linux? && Hardware::CPU.arm64?
      ENV["CGO_ENABLED"] = "1"
      ENV["GO_EXTLINK_ENABLED"] = "1"
      ENV.append "GOFLAGS", "-buildmode=pie"
    end

    # Browser login needs webkitgtk-6.0 (GTK 4), but `webkitgtk` is built for GTK 3
    system "go", "build", *std_go_args(tags: "nowebkit")
  end

  test do
    # dissent is a GUI application
    cmd = "#{bin}/dissent --help"

    pid = nil
    if OS.linux?
      IO.pipe do |read_io, write_io|
        pid = spawn(formula_opt_bin("xorg-server")/"Xvfb", "-displayfd", write_io.fileno.to_s, write_io => write_io)
        write_io.close
        ENV["DISPLAY"] = ":#{read_io.read.strip}"
      end
    end

    assert_match "Show all help options", shell_output(cmd)
  ensure
    if pid
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
