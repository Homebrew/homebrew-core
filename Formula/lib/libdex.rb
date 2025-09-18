class Libdex < Formula
  desc "Future-based programming for GLib-based applications"
  homepage "https://gitlab.gnome.org/GNOME/libdex"
  url "https://gitlab.gnome.org/GNOME/libdex/-/archive/1.0.0/libdex-1.0.0.tar.gz"
  sha256 "b36185e2a51f7b605b67dbea889ee5a487009b10c4ffe4ee57f740e3b746e39c"
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
    sha256 cellar: :any, arm64_tahoe:   "d74ef293c9daa90394d446acd3fb1342b15fecb7d4485e60d0216949c03877d7"
    sha256 cellar: :any, arm64_sequoia: "6dd4afc7846c52e350c3592125feb9fe4dfb3b1436a76dc1a467fb0702783f85"
    sha256 cellar: :any, arm64_sonoma:  "ccc42ce047c0f21b6834a26030b3fab14a562acf829fb3d2213eccaa6537d308"
    sha256 cellar: :any, arm64_ventura: "5e7acdc4b9ba579acc34ef3bcddd9effa7321e687de33481194e752736e3802f"
    sha256 cellar: :any, sonoma:        "e8c5f95abe69182953f873dd4be613052a7c5b765ef010fe772e8e7aeec84671"
    sha256 cellar: :any, ventura:       "51b465184e5cc40d83bfe964f93c3e0962061abc8cb905abc580d83a51955f16"
    sha256               arm64_linux:   "080cb4dad9402929fbd9a6120e0fea64886ca33cbb076eb01b7af53a50634a85"
    sha256               x86_64_linux:  "c324d8bb769ca8a7efa4543c69dd6587813b53b66719b14e49598fb5ecb6747f"
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
