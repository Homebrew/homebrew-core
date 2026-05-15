class Libgrapheme < Formula
  desc "Unicode string library"
  homepage "https://libs.suckless.org/libgrapheme/"
  url "https://dl.suckless.org/libgrapheme/libgrapheme-3.0.0.tar.gz"
  sha256 "32585af73dda62fbcc0fed14f199aa1bc988ad01dad0bfbd06cf175d9cf3d68c"
  license "ISC"
  head "https://git.suckless.org/libgrapheme/", using: :git, branch: "master"

  livecheck do
    url "https://dl.suckless.org/libgrapheme/"
    regex(/href=.*?libgrapheme[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "df5f451622029ee5e1e85d53e9c754527925124250633e0b9df7c13beaae176f"
    sha256 cellar: :any,                 arm64_sequoia: "fc30d10212e3e2753b9df11ae83516604b0927387a03045434ce4799b32aba1b"
    sha256 cellar: :any,                 arm64_sonoma:  "c2a97fd45b2768f92820a123be312808815983c1daf4ea5615bfdc6fd4436887"
    sha256 cellar: :any,                 sonoma:        "433662111557ba36bd9fbcd35147cff1c2f7f0413d3ecedcb4e1460ad7c9f6da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "98efa088f464cf572e88af5699db2b15a326b4e06a67a072cef4b11814e200aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ba1358d8b88e8ce243d39c7eadccbccd14b13b095d6a6be4ff5240cf36e5ac59"
  end

  def install
    system "./configure"
    system "make", "PREFIX=#{prefix}", "LDCONFIG=", "install"
  end

  test do
    (testpath/"example.c").write <<~C
      #include <grapheme.h>

      int
      main(void)
      {
        return (grapheme_next_word_break_utf8("Hello World!", SIZE_MAX) != 5);
      }
    C
    system ENV.cc, "example.c", "-I#{include}", "-L#{lib}", "-lgrapheme", "-o", "example"
    system "./example"
  end
end
