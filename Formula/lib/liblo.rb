class Liblo < Formula
  desc "Lightweight Open Sound Control implementation"
  homepage "https://liblo.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/liblo/liblo/0.35/liblo-0.35.tar.gz"
  sha256 "9acc4f7e5a24f33472e9acd7e409b7bd6810a46f0a1f3cfeecea22d60f3aae13"
  license "LGPL-2.1-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c1fa7f02794de81f4e06be6c432e4d9c2647761ef00992fa3de55945540afd44"
    sha256 cellar: :any,                 arm64_sequoia: "4ff3f95735108c43158e6f0a2fe444697b9d62210d8ff51d0806693d030004f5"
    sha256 cellar: :any,                 arm64_sonoma:  "c0febe0351ee278b9c3c7428549f39c001ff7aa20257299a7a23f142c20b9c4a"
    sha256 cellar: :any,                 sonoma:        "0f827d91c8c2b1bb0bf9d131651e39e4271c79a746339357cdcb824d37a5b8c0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5d4c3a58984a078e7ba8affce24a3dff5a3075db1e1764ae0f4d87f1a3ddae6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6f0ad474a27c6483b6b41697cfcdd9ddec8eb4fe9f2f93478469a2f949aea352"
  end

  head do
    url "https://git.code.sf.net/p/liblo/git.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "doxygen" => :build

  def install
    if build.head?
      system "./autogen.sh", *std_configure_args
    else
      system "./configure", *std_configure_args
    end

    system "make", "install"
  end

  test do
    (testpath/"lo_version.c").write <<~C
      #include <stdio.h>
      #include "lo/lo.h"
      int main() {
        char version[6];
        lo_version(version, 6, 0, 0, 0, 0, 0, 0, 0);
        printf("%s", version);
        return 0;
      }
    C
    system ENV.cc, "lo_version.c", "-I#{include}", "-L#{lib}", "-llo", "-o", "lo_version"
    assert_equal version.to_str, shell_output("./lo_version")
  end
end
