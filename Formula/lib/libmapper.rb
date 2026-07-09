class Libmapper < Formula
  desc "Distributed system for media control mapping"
  homepage "http://www.libmapper.org"
  url "https://github.com/libmapper/libmapper/releases/download/2.6.1/libmapper-2.6.1.tar.gz"
  sha256 "14e5ba412040493cffc9896cf663931835c5f8a43d19485712eae159ca54503c"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "27ddf9e8e34d4d07bec8d295d5f7247ad5cf00f343a4de46be3cedaf07aeb52c"
    sha256 cellar: :any, arm64_sequoia: "c1861237377da869de11470ec21c7f26cabdbeed401a0c1ccbecaa36827931c9"
    sha256 cellar: :any, arm64_sonoma:  "e07941753f819dfe323e3b20832db125d00737ea70107844cdce144d0c4c693c"
    sha256 cellar: :any, sonoma:        "a5e8be6e931687d01507350e97e1c7107c4a6e3a80f5a5c9353e4bbad0bcc797"
    sha256 cellar: :any, arm64_linux:   "2189b711507f0a2d428e49d726cb9f8a1d2eb6e893072a652483d97c24f5d2f2"
    sha256 cellar: :any, x86_64_linux:  "4fbe2547049c6ba6a8cdadb530b2279152996f8749f3db874319fed47b75fc94"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "liblo"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdio.h>
      #include "mapper/mapper.h"
      int main() {
        printf("%s", mpr_get_version());
        return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lmapper", "-o", "test"
    assert_match version.to_s, shell_output("./test")
  end
end
