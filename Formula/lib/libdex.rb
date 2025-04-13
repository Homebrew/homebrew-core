class Libdex < Formula
  desc "Future-based programming for GLib-based applications"
  homepage "https://gitlab.gnome.org/GNOME/libdex"
  url "https://gitlab.gnome.org/GNOME/libdex/-/archive/0.10.0/libdex-0.10.0.tar.gz"
  sha256 "1795d8cb281df4e4d292725d4ed8982a424bf258f13e866bd1a3818c5bd4ea4c"
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
    sha256 cellar: :any, arm64_sequoia: "c0e9bbf2bcc49dc00563b61dc7d7af875afb2238a4ba624888507fa78497036a"
    sha256 cellar: :any, arm64_sonoma:  "7225def607ef3bf0c9e4ef35c5a4e342bfd2c50316fc6801261568d6abc7741d"
    sha256 cellar: :any, arm64_ventura: "d028731c282bd751c94e87bec4f93a3657b6b48b3f318f9cfa28f7eb3cd29bf5"
    sha256 cellar: :any, sonoma:        "b1442c9ce97b8d63af832cb2b9a0b6e0c340433e8b212131a7abf2e52034f6c4"
    sha256 cellar: :any, ventura:       "7a6ac6f6fe4b4225cec26e320f583eaba048f5091ebeda8ce983d4529c5a33cd"
    sha256               arm64_linux:   "4a02e4429ff5407511b8ed686677109a083179c634528c6079434195dc082d62"
    sha256               x86_64_linux:  "6015425230e2435737f5a901fea985eec735f26e60c0d788a0a989378a73dd50"
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
