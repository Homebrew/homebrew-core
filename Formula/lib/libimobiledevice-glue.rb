class LibimobiledeviceGlue < Formula
  desc "Library with common system API code for libimobiledevice projects"
  homepage "https://libimobiledevice.org/"
  url "https://github.com/libimobiledevice/libimobiledevice-glue/releases/download/1.3.2/libimobiledevice-glue-1.3.2.tar.bz2"
  sha256 "6489a3411b874ecd81c87815d863603f518b264a976319725e0ed59935546774"
  license "LGPL-2.1-or-later"
  head "https://github.com/libimobiledevice/libimobiledevice-glue.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "befcdfa53f96584ae27e06bb7fbb39f27bcdbdd6a0b8d9b8c32b90d8af5dc9f9"
    sha256 cellar: :any,                 arm64_sequoia: "2e0718fa644afc01576aa96df4448e9a13476681b4287973ab3fda5d79e0a52a"
    sha256 cellar: :any,                 arm64_sonoma:  "8839511835adac2934787a8a575c3dd6e02186d60db24ddb9c9aeed8a8069883"
    sha256 cellar: :any,                 arm64_ventura: "279cb7a80efc21378015aac5cc440e9fc51b922464adfcd00d08a6e3a5802785"
    sha256 cellar: :any,                 sonoma:        "0b08285aeb078331e4240420422e5330d91aba640b21c0d1f06c470deb6b9eb6"
    sha256 cellar: :any,                 ventura:       "c85de1ecdb49bc8ef1833ba82ea8987f121a7681645eb056a6b8b6b3c8689146"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5a59b43c4831f6c112f50876d8916b6144d66be4ad44741af5a49e6d3949380"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d2472064748544eb0aca6ed2bf16ca7dab2561e3c45f96094f2a98a751fc2d67"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "libplist"

  def install
    configure = build.head? ? "./autogen.sh" : "./configure"
    system configure, "--disable-silent-rules", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include "libimobiledevice-glue/utils.h"

      int main(int argc, char* argv[]) {
        char *uuid = generate_uuid();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-limobiledevice-glue-1.0", "-o", "test"
    system "./test"
  end
end
