class Girara < Formula
  desc "Common components for zathura"
  homepage "https://pwmt.org/projects/girara/"
  url "https://pwmt.org/projects/girara/download/girara-2026.02.04.tar.xz"
  sha256 "342eca8108bd05a2275e3eacb18107fa3170fa89a12c77e541a5f111f7bba56d"
  license "Zlib"

  livecheck do
    url "https://pwmt.org/projects/girara/download/"
    regex(/girara[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0ed07bd2e1e833c3b360de3e09c4a3e7a35d899a6af96aa7d3f8036bdde04aac"
    sha256 cellar: :any, arm64_sequoia: "4951f6b0bb160e46f6a3da8564da885f14928799e907b71470cc8b03307c9041"
    sha256 cellar: :any, arm64_sonoma:  "30936ee50244bebb9d81d3da45632661a9e11ed96bbf234548d11e78226eff0b"
    sha256 cellar: :any, sonoma:        "1cf9391cf1d2f22c921895f5675154d2041685d0a698e03b9aadf8548f6feb03"
    sha256               arm64_linux:   "494a9adfa607a0fe5238eb6cab449f576b5bc6ee31ea55d09582dabbceef241a"
    sha256               x86_64_linux:  "2d31420fa52a0f3420f452284cf0fc58904cbafa6e10ada3027ee75a59f93675"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "glib"

  def install
    system "meson", "setup", "build", "-Ddocs=disabled", "-Dtests=disabled", *std_meson_args
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
