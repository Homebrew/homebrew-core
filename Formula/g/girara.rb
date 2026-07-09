class Girara < Formula
  desc "Common components for zathura"
  homepage "https://pwmt.org/projects/girara/"
  url "https://pwmt.org/projects/girara/download/girara-2026.07.07.tar.xz"
  sha256 "475f154148647d45e0f1324762fe5452094147085fddf2ccef4e9725c335b0c1"
  license "Zlib"

  livecheck do
    url "https://pwmt.org/projects/girara/download/"
    regex(/girara[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "d88052d72d39fe82019505ec872d7a9dc1f7e763e73cdee2f170ae5c9082b20b"
    sha256 cellar: :any, arm64_sequoia: "bcd17e2fb207876abbf153f81e7f1c192bc770ec24bef1d5d203ceecff54fda2"
    sha256 cellar: :any, arm64_sonoma:  "a8193cd6ef5c10c53514180b26726d11390294d476138ea6ab47dcec980575ce"
    sha256 cellar: :any, sonoma:        "f861f4fd66b8a2aacf0b65d4e0387b1c0927d18cb3aa7f353e7654927bed5262"
    sha256               arm64_linux:   "23ad93ec3d29bb5e101cceb18e06947378c3d3856ccc0b63f7db19e536a0e4b3"
    sha256               x86_64_linux:  "42adab09cc87cdb8a766244bc59d8c58473862f24c0aa8228c2811ffa4449309"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "glib"

  def install
    # Upstream defaults to c_std=c23, which GCC 13 (CI) rejects; c17 is equivalent here.
    system "meson", "setup", "build", "-Ddocs=disabled", "-Dc_std=c17", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <girara/girara.h>

      int main(void) {
        GiraraTemplate* obj = girara_template_new("home@test@");
        girara_template_add_variable(obj, "test");
        girara_template_set_variable_value(obj, "test", "brew");
        char* result = girara_template_evaluate(obj);
        g_object_unref(obj);
        if (result == NULL) return 1;
        printf("%s", result);
        g_free(result);
        return 0;
      }
    C

    system ENV.cc, "test.c", "-o", "test", *shell_output("pkgconf --cflags --libs girara").chomp.split
    assert_equal "homebrew", shell_output("./test")
  end
end
