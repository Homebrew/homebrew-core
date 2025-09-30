class Ftgl < Formula
  desc "Freetype / OpenGL bridge"
  homepage "https://sourceforge.net/projects/ftgl/"
  url "https://downloads.sourceforge.net/project/ftgl/FTGL%20Source/2.1.3~rc5/ftgl-2.1.3-rc5.tar.gz"
  sha256 "5458d62122454869572d39f8aa85745fc05d5518001bcefa63bd6cbb8d26565b"
  license "MIT"

  livecheck do
    url :stable
    regex(%r{url=.*?/ftgl[._-]v?(\d+(?:\.\d+)+(?:-rc\d*)?)\.t}i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "12ddf881165473de8bdeaecb87995c36f753ca51a5be48404e5ffcf2c1571205"
    sha256 cellar: :any,                 arm64_sequoia:  "a14fb054d0fbc1e6e11904e32c02be573d3db1c72981a6badbfc61f2f214d5cb"
    sha256 cellar: :any,                 arm64_sonoma:   "4dbee18442898c2c431d5ea8de6c67170906763eb4e4eb6775735809c34bee86"
    sha256 cellar: :any,                 arm64_ventura:  "9c7cd41984f3696dd61d7ecd78c32f68f35121a1f7f8f0b2d0a9ccb2825016c2"
    sha256 cellar: :any,                 arm64_monterey: "ed10911135d6af44315967a7fe2d81e5bf1bac34347274a49545ab777bb12c86"
    sha256 cellar: :any,                 arm64_big_sur:  "85368ec5c37bb2cffd87cd30775a78956708c71749f8da56239fd93e57cf576d"
    sha256 cellar: :any,                 sonoma:         "8d04c4e2fedf981269b941a69634b3fe4bcc0a3f54730c58c186823b0c7c5958"
    sha256 cellar: :any,                 ventura:        "184d35152ccbbee8771edbed5f40d34a8864704d4d90812f2c8f247ce79e5608"
    sha256 cellar: :any,                 monterey:       "fd4e1c8a08042ce2a0f96f79e899815009fd56cafbf550f88a9eb9685ff84b7d"
    sha256 cellar: :any,                 big_sur:        "1b39e663c0bedd0b915dd60c99c5f1acdfb3ae9717cd832134de15fd48736673"
    sha256 cellar: :any,                 catalina:       "0f982773db625daa78a1c18c9e67315ede8c52850586d47d9b7a41ffcac91730"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4b6add1f77c741b0d4cf01aba4fc3a7613b66d38d0f74ce06fcc571629270b11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a53d8292298b4c6974e04fd8ab744860aec65b58149a704d9e2dad61aba0c4f6"
  end

  depends_on "pkgconf" => :test
  depends_on "freetype"

  on_linux do
    depends_on "mesa"
    depends_on "mesa-glu"
  end

  # build patch to fix type mismatch
  patch :DATA

  def install
    # If doxygen is installed, the docs may still fail to build.
    # So we disable building docs.
    inreplace "configure", "set dummy doxygen;", "set dummy no_doxygen;"

    # Skip building the example program by failing to find GLUT (MacPorts)
    # by setting --with-glut-inc and --with-glut-lib
    args = %w[
      --disable-freetypetest
      --with-glut-inc=/dev/null
      --with-glut-lib=/dev/null
    ]

    args << "--with-gl-inc=#{Formula["mesa-glu"].opt_include}" if OS.linux?
    # Help old config scripts identify arm64 linux
    args << "--build=aarch64-unknown-linux-gnu" if OS.linux? && Hardware::CPU.arm? && Hardware::CPU.is_64_bit?

    system "./configure", *args, *std_configure_args

    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <FTGL/ftgl.h>
      #include <stdio.h>

      int main() {
        FTGLfont *font = ftglCreatePixmapFont(NULL);

        ftglSetFontFaceSize(font, 72, 72);

        ftglDestroyFont(font);
        printf("Font object created and destroyed successfully.\\n");

        return 0;
      }
    C

    pkgconf_flags = shell_output("pkgconf --cflags --libs ftgl").chomp.split
    system ENV.cc, "test.c", "-o", "test", *pkgconf_flags
    system "./test"
  end
end

__END__
diff --git a/src/FTVectoriser.cpp b/src/FTVectoriser.cpp
index ea5c571..e0c4e2d 100644
--- a/src/FTVectoriser.cpp
+++ b/src/FTVectoriser.cpp
@@ -166,7 +166,7 @@ void FTVectoriser::ProcessContours()
     for(int i = 0; i < ftContourCount; ++i)
     {
         FT_Vector* pointList = &outline.points[startIndex];
-        char* tagList = &outline.tags[startIndex];
+        char* tagList = reinterpret_cast<char*>(&outline.tags[startIndex]);

         endIndex = outline.contours[i];
         contourLength =  (endIndex - startIndex) + 1;
