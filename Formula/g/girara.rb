class Girara < Formula
  desc "Common components for zathura"
  homepage "https://pwmt.org/projects/girara/"
  url "https://pwmt.org/projects/girara/download/girara-2026.07.18.tar.xz"
  sha256 "d7255635776a45d42d1e555aa425ab96caf23755442474cf240cbac966d8502f"
  license "Zlib"

  livecheck do
    url "https://pwmt.org/projects/girara/download/"
    regex(/girara[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "0d9959fc9b718f52108608d374bed4231e99ebb539eca0ab531ef767c29c6b79"
    sha256 cellar: :any, arm64_sequoia: "a96b96abc4486ba56ea0ef1d2a8d8be75af2c39b2775c2aa9d9cff14040cf252"
    sha256 cellar: :any, arm64_sonoma:  "c14607b4d9ebdcb9a505b1223898b6eaf4ea064ed536c29b1ca32cea8ce0d88f"
    sha256 cellar: :any, sonoma:        "732f6dd51d16e04e7405caf0debf639ff981ed0cd3ff76b385d92acb2bdc5a8e"
    sha256               arm64_linux:   "fa4b25e6c5f26b9fef2662a7c48fb52f9bb36b03af7ed54c835e90ee5c6a96c6"
    sha256               x86_64_linux:  "231cd63fbf4116e533b19652f8774e0206c7ead4fa767109eddb42c1dd559ea7"
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
