class Librttopo < Formula
  desc "RT Topology Library"
  homepage "https://git.osgeo.org/gitea/rttopo/librttopo"
  url "https://deb.debian.org/debian/pool/main/libr/librttopo/librttopo_1.1.0.orig.tar.gz"
  sha256 "2e2fcabb48193a712a6c76ac9a9be2a53f82e32f91a2bc834d9f1b4fa9cd879f"
  license "GPL-2.0-or-later"
  head "https://git.osgeo.org/gitea/rttopo/librttopo.git", branch: "master"

  livecheck do
    url :head
    regex(/^(?:librttopo[._-])?v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "96402f9ebcae6c7b387f95565523e927a702cee02b90253b8fa0c1e654e3a4a5"
    sha256 cellar: :any,                 arm64_sequoia:  "93fca6e17145fc8eacdc667787aa422507c03c5cc868907ef140892ac8be1394"
    sha256 cellar: :any,                 arm64_sonoma:   "4750f9f172259c35d54af6412a3d8c3af61fdc4454ceb0e527eab79a9e8a6685"
    sha256 cellar: :any,                 arm64_ventura:  "8e6b9b8c094d303209903b45c752ee33d4463751af18871da3f23cc960d779ce"
    sha256 cellar: :any,                 arm64_monterey: "9eee7c1b207b85c576f61e416c507d7b58d657f4d9e314e26ff3a964066965a3"
    sha256 cellar: :any,                 arm64_big_sur:  "531ac2ca2e4247da1ebdacac77cbd68faaf5ea5935608de9ff842ae21aa18ce0"
    sha256 cellar: :any,                 sonoma:         "e6e7886d1eb7273ee7d7b8745111f9d4eaccbc789138bcd0fb5b05ceb9883222"
    sha256 cellar: :any,                 ventura:        "defbee65cdb51949c0d48bf62f035b55b7c148f5780478f46a3fbba47e49e382"
    sha256 cellar: :any,                 monterey:       "2eb9b1d4133a764edab33bd122c2d7326b95f983edbbb4cea9bec3888be3885f"
    sha256 cellar: :any,                 big_sur:        "59068843a454371abc25ad9421771eb2770febfaa00d41e1527476f4cbfdb05b"
    sha256 cellar: :any,                 catalina:       "9512f32068f310fc02c082828e4ebac85a698ef69f370243aa00a5b873569319"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9665c432abd2195df0985819c583373e355ad0ca39d57fc05814e90194a4d745"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d6d9cbbb4846b4a3147ef8be9041c2d155e2b9c8c3b7b3720b71ec78b472667"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "geos"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <librttopo.h>

      int main(int argc, char *argv[]) {
        printf("%s", rtgeom_version());
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lrttopo", "-o", "test"
    assert_equal stable.version.to_s, shell_output("./test")
  end
end
