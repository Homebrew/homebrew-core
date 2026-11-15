class Dissent < Formula
  desc "GTK4 Discord client in Go"
  homepage "https://github.com/diamondburned/dissent"
  url "https://github.com/diamondburned/dissent/archive/refs/tags/v0.0.41.tar.gz"
  sha256 "d31559e994798b47b3cf1440db3565fa0cfff7a9b1c67e49470509569cb8963e"
  license "GPL-3.0-or-later"
  head "https://github.com/diamondburned/dissent.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "c664a0a6ef1090025b348fe7765f3edb1d5e5ceb1407230cef6682a5c919a571"
    sha256 cellar: :any, arm64_tahoe:       "d9aeb502ce1e2a70103b671d396eb60e2c1372eae453b18d84068e858d8d5f96"
    sha256 cellar: :any, arm64_sequoia:     "e953880852ef75e6144a10e3d0f13670bee8ca36c05c2b1c9603d96d81003317"
    sha256 cellar: :any, arm64_linux:       "45b6f3b96547ba929b9f3850fee82d7b2f09e99beaf6cac602febed70f7b6a72"
    sha256 cellar: :any, x86_64_linux:      "00261e8d590e87f040bd7186505747da3bc29f928a619174f39ea8d403c3f366"
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

    system "go", "build", *std_go_args
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
