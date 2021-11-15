class Libxkbcommon < Formula
  desc "Keyboard handling library"
  homepage "https://xkbcommon.org/"
  url "https://xkbcommon.org/download/libxkbcommon-1.3.1.tar.xz"
  sha256 "b3c710d27a2630054e1e1399c85b7f330ef03359b460f0c1b3b587fd01fe9234"
  license "MIT"
  head "https://github.com/xkbcommon/libxkbcommon.git"

  bottle do
    sha256 arm64_monterey: "a0e6a5b584a7f3fc1d50a73fe23219fece03acfccde7aefc64eb02b387ada6bd"
    sha256 arm64_big_sur:  "1eb1269f05403fc56cde1b2ba18316db80c3d7bc06343c744856df94a35fca05"
    sha256 monterey:       "f188db08d139bacbbddc51db54a85f48325dfa7b1d584317f141dffe8c603e84"
    sha256 big_sur:        "725ffc225899f82dd3e8af9faeb901fbc688e4d420ceb4f935f48110e178e68c"
    sha256 catalina:       "87cb22b633159f05b819d5642dfecebcfb5a9151a1745d3643288732b648eaa7"
    sha256 mojave:         "330abe48ff8ed73dd8233435f3ed05ef0e9cfaf003c9c9e08d68eb1d3c3def23"
    sha256 x86_64_linux:   "8ea3f2ea30b4160fe4f1ce40fba19837890e1976b73da41e9f87f09d68ee897b"
  end

  depends_on "bison" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "libx11"
  depends_on "libxcb"
  depends_on "xkeyboardconfig"

  uses_from_macos "libxml2"

  def install
    args = %W[
      -Denable-wayland=false
      -Denable-docs=false
      -Dxkb-config-root=#{HOMEBREW_PREFIX}/share/X11/xkb
      -Dx-locale-root=#{HOMEBREW_PREFIX}/share/X11/locale
    ]
    mkdir "build" do
      system "meson", *std_meson_args, *args, ".."
      system "ninja", "install", "-v"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdlib.h>
      #include <xkbcommon/xkbcommon.h>
      int main() {
        return (xkb_context_new(XKB_CONTEXT_NO_FLAGS) == NULL)
          ? EXIT_FAILURE
          : EXIT_SUCCESS;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lxkbcommon",
                   "-o", "test"
    system "./test"
  end
end
