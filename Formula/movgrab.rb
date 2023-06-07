class Movgrab < Formula
  desc "Downloader for youtube, dailymotion, and other video websites"
  homepage "https://sites.google.com/site/columscode/home/movgrab"
  url "https://github.com/ColumPaget/Movgrab/archive/3.1.2.tar.gz"
  sha256 "30be6057ddbd9ac32f6e3d5456145b09526cc6bd5e3f3fb3999cc05283457529"
  license "GPL-3.0-or-later"
  revision 5

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7fbbd62fc17257b90c9fe91b83062f2d42c8e7112c74e38e3f9e69ac08c59f39"
    sha256 cellar: :any,                 arm64_monterey: "17ab24e1802ce6001bac7698b77016147e3cd65e08b00bd306d83dbdbda24a47"
    sha256 cellar: :any,                 arm64_big_sur:  "a59426ffc7941233eebd052796c1827884fe9ba508dbc57d2f24d8b1d1e64a59"
    sha256 cellar: :any,                 ventura:        "4d3a6b36fc96ea07500f4102847be29b9de1d0cc77555a8ed49465d97cc38301"
    sha256 cellar: :any,                 monterey:       "a4a6388501b014b23c14682d78350ad7f80e2cdf13990db1ab426680cd5fe46b"
    sha256 cellar: :any,                 big_sur:        "711c6f888dd3aee65b4f8b095a833f14c7bb14d4c6ab972825a64f565e3627c3"
    sha256 cellar: :any,                 catalina:       "08e18d14b3208844a4fdf805ea914770c4ea140ae1e11d643b425e5ecf50abcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae91e23b93a7761f927bb2aa7dd68af847fe70d0b873a4e93f4b7af6fdf86d0c"
  end

  depends_on "libressl"

  uses_from_macos "zlib"

  # Fixes an incompatibility between Linux's getxattr and macOS's.
  # Reported upstream; half of this is already committed, and there's
  # a PR for the other half.
  # https://github.com/ColumPaget/libUseful/issues/1
  # https://github.com/ColumPaget/libUseful/pull/2
  patch do
    url "https://github.com/Homebrew/formula-patches/raw/936597e74d22ab8cf421bcc9c3a936cdae0f0d96/movgrab/libUseful_xattr_backport.diff"
    sha256 "d77c6661386f1a6d361c32f375b05bfdb4ac42804076922a4c0748da891367c2"
  end

  # Backport fix for GCC linker library search order
  # Upstream ref: https://github.com/ColumPaget/Movgrab/commit/fab3c87bc44d6ce47f91ded430c3512ebcf7501b
  patch :DATA

  def install
    # Can you believe this? A forgotten semicolon! Probably got missed because it's
    # behind a conditional #ifdef.
    # Fixed upstream: https://github.com/ColumPaget/libUseful/commit/6c71f8b123fd45caf747828a9685929ab63794d7
    inreplace "libUseful-2.8/FileSystem.c", "result=-1", "result=-1;"

    # Later versions of libUseful handle the fact that setresuid is Linux-only, but
    # this one does not. https://github.com/ColumPaget/Movgrab/blob/HEAD/libUseful/Process.c#L95-L99
    inreplace "libUseful-2.8/Process.c", "setresuid(uid,uid,uid)", "setreuid(uid,uid)"

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--enable-ssl"
    system "make"

    # because case-insensitivity is sadly a thing and while the movgrab
    # Makefile itself doesn't declare INSTALL as a phony target, we
    # just remove the INSTALL instructions file so we can actually
    # just make install
    rm "INSTALL"
    system "make", "install"
  end

  test do
    system "#{bin}/movgrab", "--version"
  end
end

__END__
diff --git a/Makefile.in b/Makefile.in
index 04ea67d..5516051 100755
--- a/Makefile.in
+++ b/Makefile.in
@@ -11,7 +11,7 @@ OBJ=common.o settings.o containerfiles.o outputfiles.o servicetypes.o extract_te

 all: $(OBJ)
 	@cd libUseful-2.8; $(MAKE)
-	$(CC) $(FLAGS) -o movgrab main.c $(LIBS) $(OBJ) libUseful-2.8/libUseful-2.8.a
+	$(CC) $(FLAGS) -o movgrab main.c $(OBJ) libUseful-2.8/libUseful-2.8.a $(LIBS)

 clean:
 	@rm -f movgrab *.o libUseful-2.8/*.o libUseful-2.8/*.a libUseful-2.8/*.so config.log config.status
diff --git a/libUseful-2.8/DataProcessing.c b/libUseful-2.8/DataProcessing.c
index 3e188a8..56087a6 100755
--- a/libUseful-2.8/DataProcessing.c
+++ b/libUseful-2.8/DataProcessing.c
@@ -420,8 +420,8 @@ switch(val)

 if (Data->Cipher)
 {
-Data->enc_ctx=(EVP_CIPHER_CTX *) calloc(1,sizeof(EVP_CIPHER_CTX));
-Data->dec_ctx=(EVP_CIPHER_CTX *) calloc(1,sizeof(EVP_CIPHER_CTX));
+Data->enc_ctx=EVP_CIPHER_CTX_new();
+Data->dec_ctx=EVP_CIPHER_CTX_new();
 EVP_CIPHER_CTX_init(Data->enc_ctx);
 EVP_CIPHER_CTX_init(Data->dec_ctx);
 Data->BlockSize=EVP_CIPHER_block_size(Data->Cipher);
