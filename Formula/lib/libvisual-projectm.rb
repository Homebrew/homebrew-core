class LibvisualProjectm < Formula
  desc "Visualization plug-in for projectM support from Libvisual"
  homepage "https://github.com/projectM-visualizer/frontend-libvisual-plug-in"
  url "https://github.com/projectM-visualizer/frontend-libvisual-plug-in/archive/refs/tags/v2.1.2.tar.gz"
  sha256 "b83cd19bfaaa35254489bac3dec315ff305171e19cf19387644c3c5c56207208"
  license "GPL-3.0-or-later"

  bottle do
    sha256                               arm64_golden_gate: "e34810e34d368a8a3203e98878c626dcc2d0f3965cb452898785195d2f45cc86"
    sha256                               arm64_tahoe:       "859857caed5c2cd954dbcbc27024d76eab9c9b6d34444d3a941d00577a4cb723"
    sha256                               arm64_sequoia:     "2cf5ca8c0590b88e843a67b0b45c3e169403474dbe7789bf4e7653dc005022d7"
    sha256                               arm64_sonoma:      "b20d989cfe6113ef1004dcffd1ad1fdedbbd33cf6b0d96e68ea3015ca4abf4d5"
    sha256                               sonoma:            "cde4f874618e5510008df0e300a7f758ec438559ddc470d9046fd2864fa7110b"
    sha256                               arm64_linux:       "c15daec0a30a65bdabed7f628999eaf83c8c4bb89da4609d05c297749832c510"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "690a7080b1b273f44e57a7d3b41908f2806e39add912dac5f9146009fbcc1032"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build

  depends_on "libvisual"
  depends_on "projectm"

  deny_network_access!

  def install
    # NOTE: We cannot write to libvisual's cellar, so we deflect
    #       installation and leverage brew's auto-symlinking
    #       to <HOMEBREW_PREFIX>/lib/libvisual-<major>.<minor>/actor .
    libvisual = Formula["libvisual"]
    inreplace "CMakeLists.txt",
      "LIBRARY DESTINATION \"${LIBVISUAL_ACTOR_PLUGINS_DIR}\"",
      "LIBRARY DESTINATION \"#{lib}/libvisual-#{libvisual.version.major_minor}/actor\""

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    doc.install "AUTHORS.md" => "AUTHORS"
  end

  test do
    # `lv-tool` starts through SDL 1.2's Cocoa `SDLmain`, which never finishes launching in the test sandbox
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include <libvisual/libvisual.h>

      int main(int argc, char **argv) {
        visual_init(&argc, &argv);
        if (!visual_actor_valid_by_name("projectM")) return 1;
        VisActor *actor = visual_actor_new("projectM");
        if (actor == NULL) return 2;
        puts(visual_actor_get_plugin(actor)->info->plugname);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-o", "test", "-I#{formula_opt_include("libvisual")}/libvisual-0.4",
                   "-L#{formula_opt_lib("libvisual")}", "-lvisual-0.4"
    assert_equal "projectM", shell_output("./test").strip
  end
end
