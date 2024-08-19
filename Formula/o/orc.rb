class Orc < Formula
  desc "Oil Runtime Compiler (ORC)"
  homepage "https://gstreamer.freedesktop.org/projects/orc.html"
  url "https://gstreamer.freedesktop.org/src/orc/orc-0.4.39.tar.xz"
  sha256 "33ed2387f49b825fa1b9c3b0072e05f259141b895474ad085ae51143d3040cc0"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause"]

  livecheck do
    url "https://gstreamer.freedesktop.org/src/orc/"
    regex(/href=.*?orc[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4f3442b350f46d9a8ebfbcdf5c82582f4a2ada1a84fa68da9d3ad19159c97d04"
    sha256 cellar: :any,                 arm64_ventura:  "c229e6d5bc16400788f57f76937e58b711b80d5005e548831ba23d9a80419779"
    sha256 cellar: :any,                 arm64_monterey: "04be4fa75c493e4502473784a6389cccccf4d56cf9481b00b4f19cbf80d36f23"
    sha256 cellar: :any,                 sonoma:         "6259f9bb3c048c8c657dae12a83dd9513fcc4b805d2e75eaf441e2e74f6dcbd7"
    sha256 cellar: :any,                 ventura:        "f8463e64bfa4c2c204f3792c73e59b3f7984529781da1a65f96600b36e46e2b5"
    sha256 cellar: :any,                 monterey:       "2091fd07f0328990472ff612edd54bfd73b72aa3085d98bfa4a6f660ef378a24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0047bf5ef440689f7fe75c904c7f51b0aefba7df91b78d294538258c2ea9999e"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  def install
    system "meson", "setup", "build", "-Dgtk_doc=disabled", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/orcc --version 2>&1")

    (testpath/"test.c").write <<~EOS
      #include <orc/orc.h>

      int main(int argc, char *argv[]) {
        if (orc_version_string() == NULL) {
          return 1;
        }
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}/orc-0.4", "-L#{lib}", "-lorc-0.4", "-o", "test"
    system "./test"
  end
end
