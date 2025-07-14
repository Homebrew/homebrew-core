class Libdex < Formula
  desc "Future-based programming for GLib-based applications"
  homepage "https://gitlab.gnome.org/GNOME/libdex"
  url "https://gitlab.gnome.org/GNOME/libdex/-/archive/0.10.1/libdex-0.10.1.tar.gz"
  sha256 "3511e4ff25e5d82b7097d9602bc569bea7d3dc816c6fbbf1af68383f74ad9dd5"
  license "LGPL-2.1-or-later"
  head "https://gitlab.gnome.org/GNOME/libdex.git", branch: "main"

  # We restrict matching to versions with an even-numbered minor version number,
  # as an odd-numbered minor version number indicates a development version:
  # https://gitlab.gnome.org/GNOME/libdex/-/issues/22#note_2368290
  livecheck do
    url :stable
    regex(/^v?(\d+\.\d*[02468](?:\.\d+)*)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "0636c5633f7850379d5e57caf003ba6d6d94dcb7d33073d9e291f1f6c71375ef"
    sha256 cellar: :any, arm64_sonoma:  "8323fd17f261bd46710243cbe126f6d2fa910a8296a0de9eba6e00ab2740f861"
    sha256 cellar: :any, arm64_ventura: "01ec6b248017f0c2b993ae4b961ed5c06466f8528f8be5a82c1919d691f43b07"
    sha256 cellar: :any, sonoma:        "4daaf450ea68ed0073571dc5f1dd9cd57f0983703e71ea47f6a115e8bbe8a768"
    sha256 cellar: :any, ventura:       "9cf19cc312f923eb00089ca98ac6fdfa85694646d851c2cf6f170012d1a739a8"
    sha256               arm64_linux:   "8f205780d539d5a864976581e5fbb630eff9ebade64ed2fef8b771735aec58c0"
    sha256               x86_64_linux:  "f2715f5e1b87afb3198707d11857fc37486ca367a8f7d2e545c0f93a58c5f060"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "vala" => :build # for vapigen
  depends_on "glib"

  def install
    args = %w[
      -Dexamples=false
      -Dtests=false
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    pkgshare.install "examples", "build/config.h"
  end

  test do
    cp %w[examples/cp.c config.h].map { |file| pkgshare/file }, "."

    ENV.append_to_cflags "-I."
    ENV.append_to_cflags shell_output("pkgconf --cflags libdex-1").chomp
    ENV.append "LDFLAGS", shell_output("pkgconf --libs-only-L libdex-1").chomp
    ENV.append "LDLIBS", shell_output("pkgconf --libs-only-l libdex-1").chomp

    system "make", "cp"

    text = Random.rand.to_s
    (testpath/"test").write text
    system "./cp", "test", "not-test"
    assert_equal text, (testpath/"not-test").read
  end
end
