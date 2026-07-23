class Libdom < Formula
  desc "Implementation of the W3C DOM"
  homepage "https://www.netsurf-browser.org/projects/libdom/"
  url "https://download.netsurf-browser.org/libs/releases/libdom-0.4.2-src.tar.gz"
  sha256 "d05e45af16547014c2b0a3aecf3670fa13d419f505b3f5fc7ac8a1491fc30f3c"
  license "MIT"

  livecheck do
    url "https://download.netsurf-browser.org/libs/releases/"
    regex(/href=.*?libdom[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "07e72502e60856ec4307b60f6784aebbc6d59c3fc54da2a46c7416f78162b081"
    sha256 cellar: :any,                 arm64_sequoia: "5305da928bb33e1c7fe5b85b44e644d17237c0e368fcc0bf159d82dd42626485"
    sha256 cellar: :any,                 arm64_sonoma:  "496e88188a61218223af1157766d192764aeb9c36ef5bfb2e057fc403e7d2793"
    sha256 cellar: :any,                 arm64_ventura: "67205b439af8580d452d27c87f291f8345d3deb3c194505527fdd426bd75d0db"
    sha256 cellar: :any,                 sonoma:        "d71ecaff24c596ef7f918e9f025e95f969d4f4368823106bdb7ab99d7f31ce64"
    sha256 cellar: :any,                 ventura:       "e55aa034a7edd4f1d7aab94e7e1e4eb21bad5c9816aea969c6ddc561fbc1b60f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "677af5b19154760fd5048c6acecffdfe1596c60ea79520f9e3e9412f1870af55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "65f04a61a7747e494540603b837878cb887eda1c01e2d744caa9a19a30213204"
  end

  depends_on "netsurf-buildsystem" => :build
  depends_on "pkgconf" => [:build, :test]
  depends_on "libhubbub"
  depends_on "libparserutils"
  depends_on "libwapcaplet"

  uses_from_macos "expat"

  def install
    args = %W[
      NSSHARED=#{Formula["netsurf-buildsystem"].opt_pkgshare}
      PREFIX=#{prefix}
    ]

    system "make", "install", "COMPONENT_TYPE=lib-shared", *args
  end

  test do
    (testpath/"test.c").write <<~C
      #include <dom/dom.h>
      #include <stdint.h>

      int main() {
        const uint8_t *data = (const uint8_t *)"test";
        dom_string *str;
        dom_exception ex = dom_string_create(data, 4, &str);
        return ex == DOM_NO_ERR ? 0 : 1;
      }
    C

    flags = shell_output("pkgconf --cflags --libs libdom").chomp.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
