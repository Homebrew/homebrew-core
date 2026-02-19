class Cgdb < Formula
  desc "Curses-based interface to the GNU Debugger"
  homepage "https://cgdb.github.io/"
  url "https://cgdb.me/files/cgdb-0.8.0.tar.gz"
  sha256 "0d38b524d377257b106bad6d856d8ae3304140e1ee24085343e6ddf1b65811f1"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://cgdb.me/files/"
    regex(/href=.*?cgdb[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 arm64_tahoe:    "960dae291afe8d9e0ce627ee8c4d0fd2a521fdc7f0b731f4c7c5d7830a60ae2f"
    sha256 arm64_sequoia:  "dac79a6089d98cfbe4c2b9083d34c0558227e6888546e76c0d425550cb808f30"
    sha256 arm64_sonoma:   "f30227f01c96e73fa96c6eae457149108dc258cad4845ba3a36bdad6b3d25d67"
    sha256 arm64_ventura:  "2c71862edb76b37a42f6d41f2f461a56313bb6e56139ab78fe32ee0fe1cea7c5"
    sha256 arm64_monterey: "cf029cddf3d08875c2f363d6ed9df10bfb944830d448557784e669138a3aefa5"
    sha256 arm64_big_sur:  "1dfbebad73683e283033ce308c131a9509a1db30df30830f8177c08f631b69c4"
    sha256 sonoma:         "c4c164c45ecb6b54b8bc50593eec22c19f33671ebaa9a228895eb8806d5dc052"
    sha256 ventura:        "d959481de39f00122a3274092eebb71c62892c0a2abbee8f59fbb3c1040a5c16"
    sha256 monterey:       "8fd498ac0f53354ec1b2298e5b6d0bf5d11f2047ca0df29b44b3b31a6bf89682"
    sha256 big_sur:        "82301d4bbc42f2feea9b20676554ed96360d7ce7626b5ef02afb6e76983818f6"
    sha256 catalina:       "0cf4c2cd5ed2f6b831581d06d3f9614007aaecc16bc4ba0a1fce85afa81a11ee"
    sha256 arm64_linux:    "6a3ab90cdc4efe81a78b89511057f673b90bb5585cfd707fb9565b2c4cd6627d"
    sha256 x86_64_linux:   "cb3a12c3700e55375cffe843a4bdf8e4fe2541219dc1da35304f7dbece2f5809"
  end

  head do
    url "https://github.com/cgdb/cgdb.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "help2man" => :build
  depends_on "readline"

  uses_from_macos "flex" => :build
  uses_from_macos "ncurses"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  # patch for readline check code, upstream pr ref, https://github.com/cgdb/cgdb/pull/359
  patch :DATA

  def install
    system "sh", "autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-readline=#{Formula["readline"].opt_prefix}"
    system "make", "install"
  end

  test do
    system bin/"cgdb", "--version"
  end
end

__END__
diff --git a/configure b/configure
index c564dc1..e13c67c 100755
--- a/configure
+++ b/configure
@@ -6512,7 +6512,7 @@ else
 #include <stdlib.h>
 #include <readline/readline.h>

-main()
+int main()
 {
 	FILE *fp;
 	fp = fopen("conftest.rlv", "w");
