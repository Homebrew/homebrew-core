class Bitchx < Formula
  desc "Text-based, scriptable IRC client"
  homepage "https://bitchx.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/bitchx/ircii-pana/bitchx-1.2.1/bitchx-1.2.1.tar.gz"
  sha256 "2d270500dd42b5e2b191980d584f6587ca8a0dbda26b35ce7fadb519f53c83e2"
  revision 1

  bottle do
    sha256 arm64_monterey: "894ac54efedb3043b3b5551bb74a8aaaa827e20c46a2a54ab4e1b4d9441148a0"
    sha256 arm64_big_sur:  "628166ae821a5f6e24e522aacf347d3789f4c16deeb060e234ba333432ee6dd7"
    sha256 monterey:       "19e1912dbebb6abceee71fe4007be1c7d770035675ee39ba70851fe89ba0abf0"
    sha256 big_sur:        "5c97a97f3f4633129252dbe9691dbfd23960469fca3214326f465cb94f2089dd"
    sha256 catalina:       "9e24f64d188be8be36054aad67ead05bffd2f1b5a7c6bef6bc9f98f7ea92fb87"
    sha256 mojave:         "52939d589b5697402b6b5c658ab065651ac1943e8c7c7c9798aca5f76790be00"
    sha256 high_sierra:    "0a021e6d01b7f7d4ee9d048459ab7367b48da791896b2edeb96e270b196ff202"
    sha256 sierra:         "0c9e7fcf39a8fb0c80f867495cf1d6776fbe4aec6010a1986edbca820ed7a6f0"
  end

  depends_on "openssl@1.1"

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  # Apply this upstream commit to fix Linux build:
  # https://sourceforge.net/p/bitchx/git/ci/1c6ff3088ad01a15bea50f78f1b2b468db7afae9/
  # Remove with next release.
  patch :DATA

  def install
    # Patch to fix OpenSSL detection with OpenSSL 1.1
    # A similar fix is already committed upstream:
    # https://sourceforge.net/p/bitchx/git/ci/184af728c73c379d1eee57a387b6012572794fa8/
    inreplace "configure", "SSLeay", "OpenSSL_version_num"

    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--enable-ipv6",
                          "--with-plugins=acro,aim,arcfour,amp,autocycle,blowfish,cavlink,encrypt,fserv," \
                          "hint,identd,nap,pkga,possum,qbx,qmail",
                          "--with-ssl"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"BitchX", "-v"
  end
end

__END__
diff --git a/dll/amp/layer2.c b/dll/amp/layer2.c
index d4c4d95..2b7d412 100644
--- a/dll/amp/layer2.c
+++ b/dll/amp/layer2.c
@@ -77,7 +77,7 @@ int hsize,fs,mean_frame_size;
 					   nbal=&t_nbal2;
 					   sblimit=8;
 					   break;
-				default  : /*printf(" bit alloc info no gud ");*/
+				default  : break;
 				}
 				break;
 		case 1 : switch (bitrate)	/* 1 = 48 kHz */
@@ -98,7 +98,7 @@ int hsize,fs,mean_frame_size;
 					   nbal=&t_nbal2;
 					   sblimit=8;
 					   break;
-				default  : /*printf(" bit alloc info no gud ");*/
+				default  : break;
 				}
 				break;
 		case 2 : switch (bitrate)	/* 2 = 32 kHz */
@@ -122,10 +122,10 @@ int hsize,fs,mean_frame_size;
                                    nbal=&t_nbal3;
                                    sblimit=12;
 				   break;
-			default  : /*printf("bit alloc info not ok\n");*/
+			default  : break;
 			}
 	                break;                                                    
-		default  : /*printf("sampling freq. not ok/n");*/
+		default  : break;
 	} else {
 		bit_alloc_index=&t_allocMPG2;
 		nbal=&t_nbalMPG2;
