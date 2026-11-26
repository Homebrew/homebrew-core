class FileRoller < Formula
  desc "GNOME archive manager"
  homepage "https://wiki.gnome.org/Apps/FileRoller"
  url "https://download.gnome.org/sources/file-roller/44/file-roller-44.8.tar.xz"
  sha256 "40a560efe9fff957376fd92358580839acc79e2065addbf8491f7a14438c5755"
  license "GPL-2.0-or-later"

  bottle do
    manifest_sha256 "052a0fd570620f2c6ab2a3ab71fc3541f7ec13ce57dc67df47234680e1fe3dc9"
    sha256 arm64_golden_gate: "3c3dc6c47c4107cf489201e47eb5e2d69c4f56cdfbd58eda151d4bbd5de515f2"
    sha256 arm64_tahoe:       "709d9681bfe54f3605b9a5f14f15f8c40b998231f7aabc0179eb93463a43d60c"
    sha256 arm64_sequoia:     "a11745caeb911951a4103ad42640733644a0be448a3cb6583c2e013045156af5"
    sha256 arm64_linux:       "0af07070a0f6a0fdd157d92f8b54df3441e3078c7af318f8af325ec3d812d042"
    sha256 x86_64_linux:      "32b70469ab052631fe7f09e25e0f5d9aa5f473fd78f934bdd2bb83fe38a58348"
  end

  depends_on "gettext" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => :build
  depends_on "adwaita-icon-theme"
  depends_on "desktop-file-utils"
  depends_on "glib"
  depends_on "gtk4"
  depends_on "hicolor-icon-theme"
  depends_on "json-glib"
  depends_on "libadwaita"
  depends_on "libarchive"
  depends_on "pango"

  on_macos do
    depends_on "gettext"
  end

  on_linux do
    depends_on "xorg-server" => :test
  end

  def install
    ENV["DESTDIR"] = "/"

    system "meson", "setup", "build", "-Dpackagekit=false", "-Duse_native_appchooser=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  post_install_steps do
    compile_gsettings_schemas
    update_gtk_icon_cache
    update_desktop_database
  end

  test do
    pids = []
    if OS.linux?
      IO.pipe do |read_io, write_io|
        pids << spawn(formula_opt_bin("xorg-server")/"Xvfb", "-displayfd", write_io.fileno.to_s, write_io => write_io)
        write_io.close
        ENV["DISPLAY"] = ":#{read_io.read.strip}"
      end
    end
    assert_match "Create and modify an archive", shell_output("#{bin}/file-roller --help")
  ensure
    pids.reverse_each do |pid|
      Process.kill "TERM", pid
      Process.wait pid
    end
  end
end
