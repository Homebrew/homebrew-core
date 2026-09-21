class LibvisualPlugins < Formula
  desc "Audio Visualization tool and library"
  homepage "https://github.com/Libvisual/libvisual"
  url "https://github.com/Libvisual/libvisual/releases/download/libvisual-plugins-0.4.2/libvisual-plugins-0.4.2.tar.gz"
  sha256 "55988403682b180d0de5e6082f804f3cf066d9a08e887b10eb6a315eb40d9f87"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later", "LGPL-2.1-or-later"]

  bottle do
    rebuild 1
    sha256 arm64_golden_gate: "f7b760e8dda2d8e5a4c60d65828cf1a7b4c2699957022eed2e295ac1f49e03ac"
    sha256 arm64_tahoe:       "cee3c8717fa02d4ae61e93f3c5c18a3715b82ff6b66536b0433177f7c85b3b90"
    sha256 arm64_sequoia:     "23cb3d6dfaf0b7a7fa70f093e800bde199612aed1a5a36a8be3b1a3fc15c5b17"
    sha256 arm64_sonoma:      "9eb6300887acb38de62a8542d9e788cbb5669b1e5c70d496d2449df0be903ab5"
    sha256 sonoma:            "8cb3635fca546794cc10609553167e5afff55b617c0c5f1406b1256a5387a699"
    sha256 arm64_linux:       "6d4b21f6ac9b7b5cf97d907870b3770aa9b8dbbbc6a03a6285d7009ac6ffe662"
    sha256 x86_64_linux:      "2f2d4dd00ede7314b3243fc7def5ad770b90539c83b0b921e58b6f86e6f57808"
  end

  depends_on "pkgconf" => :build

  depends_on "jack"
  depends_on "libvisual"

  uses_from_macos "bison" => :build

  on_macos do
    depends_on "portaudio"
  end

  on_linux do
    depends_on "alsa-lib"
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "pulseaudio"
  end

  def install
    libvisual = Formula["libvisual"]
    configure_args = [
      "--disable-gdkpixbuf-plugin",
      "--disable-gforce",
      "--disable-gstreamer-plugin",
      # NOTE: This relies on brew's auto-symlinking to
      #       <HOMEBREW_PREFIX>/lib/libvisual-<major>.<minor> .
      "--with-plugins-base-dir=#{lib}/libvisual-#{libvisual.version.major_minor}",
    ]
    system "./configure", *configure_args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    # `lv-tool` starts through SDL 1.2's Cocoa `SDLmain`, which never finishes launching in the test sandbox
    audio = OS.mac? ? "portaudio" : "pulseaudio"
    (testpath/"test.c").write <<~C
      #include <libvisual/libvisual.h>

      int main(int argc, char **argv) {
        visual_init(&argc, &argv);
        if (!visual_input_valid_by_name("debug")) return 1;
        if (!visual_actor_valid_by_name("lv_gltest")) return 2;
        if (!visual_input_valid_by_name("#{audio}")) return 3;
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-I#{formula_opt_include("libvisual")}/libvisual-0.4",
                   "-L#{formula_opt_lib("libvisual")}", "-lvisual-0.4"
    system "./test"
  end
end
