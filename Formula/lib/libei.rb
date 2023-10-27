class Libei < Formula
  desc "Emulated Input library"
  homepage "https://gitlab.freedesktop.org/libinput/libei"
  url "https://gitlab.freedesktop.org/libinput/libei/-/archive/1.1.0/libei-1.1.0.tar.bz2"
  sha256 "b9868dc64ba0549c7034ba0828bd9973f21e542036d25a662de4dfbc26a6b867"
  license "MIT"

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.12" => :build
  depends_on :linux
  depends_on "systemd"

  def install
    system "meson", "setup", "build", "-Dtests=disabled", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    output = shell_output("#{bin}/ei-debug-events --verbose 2>&1", 1)
    assert_match "Failed to setup backend", output
  end
end
