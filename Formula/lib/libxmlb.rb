class Libxmlb < Formula
  include Language::Python::Shebang

  desc "Library for querying compressed XML metadata"
  homepage "https://github.com/hughsie/libxmlb"
  url "https://github.com/hughsie/libxmlb/releases/download/0.3.24/libxmlb-0.3.24.tar.xz"
  sha256 "ded52667aac942bb1ff4d1e977e8274a9432d99033d86918feb82ade82b8e001"
  license "LGPL-2.1-or-later"
  head "https://github.com/hughsie/libxmlb.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "820c0040548452b06ca623643dc146e712781c84434e5036c22fb68ea3004c58"
    sha256 cellar: :any, arm64_sequoia: "076c9633094a79b1113f39d272441c425fe2c9bdcce285734a2a7abd936e4296"
    sha256 cellar: :any, arm64_sonoma:  "1a990dd0c371858b1b8ed1e1c82dfedf7c7b82ec5f1fe69388cdd2b0ad17c4a2"
    sha256 cellar: :any, arm64_ventura: "c8f5547e8b762c2ee17821cacedaffeea8750cb32066040edffcc56e5ff83439"
    sha256 cellar: :any, sonoma:        "3f500fa25e7184a9d3e68cb1ca8babc6cec7e1aa5ae37b84f16fb32b77954fc3"
    sha256 cellar: :any, ventura:       "1dc485d863cceae8b7250b396a76b20f472e91113149a57d84c93ee11ee1ad41"
    sha256               arm64_linux:   "708cdbee4d3d58969c136c6398799af42e0c23f3799a5b91f70285df4511569c"
    sha256               x86_64_linux:  "db85fc0227bc63aa76a53522b14407d20641f367ecf43e349ef3cdb4830087ae"
  end

  depends_on "gi-docgen" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "python@3.14" => :build
  depends_on "vala" => :build
  depends_on "glib"
  depends_on "xz"
  depends_on "zstd"

  def install
    rewrite_shebang detected_python_shebang(use_python_from_path: true), "src/generate-version-script.py"

    system "meson", "setup", "build", "-Dgtkdoc=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"xb-tool", "-h"

    (testpath/"test.c").write <<~C
      #include <xmlb.h>
      int main(int argc, char *argv[]) {
        XbBuilder *builder = xb_builder_new();
        g_assert_nonnull(builder);
        return 0;
      }
    C

    flags = shell_output("pkgconf --cflags --libs xmlb").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
