class Biosig < Formula
  desc "Tools for biomedical signal processing and data conversion"
  homepage "https://biosig.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/biosig/BioSig%20for%20C_C%2B%2B/src/biosig-2.6.1.src.tar.xz"
  sha256 "558ee17cd7b4aa1547e98e52bb85cccccb7f7a81600f9bef3a50cd5b34d0729e"
  license "GPL-3.0-or-later"
  revision 1

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:biosig|biosig4c[^-]*?)[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "117069306a551af329ca174824f8e68f8ecbfc9285ef33a0b9457137dafd1ca9"
    sha256 cellar: :any,                 arm64_sonoma:  "2afa576649a1ce599abd86cf16c92e8137e1fd5513401c0f91635c679f23732a"
    sha256 cellar: :any,                 arm64_ventura: "ec0026a9de7bed96c71de9d1e086134cb1f308582cd41f70457cc4fcd01b941b"
    sha256 cellar: :any,                 sonoma:        "3004a0bb2aa939134d7823a4db2355ea83f4fd9866870a6b9bbf1686e85a31e0"
    sha256 cellar: :any,                 ventura:       "3615427d4eaba6e8322770bdce3d29033bd8361a5613d682033e1477c4ce416c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e74145def1020e92731a83f67b2a805ecd74871cfe4936c425fa95a5de396cfe"
  end

  depends_on "gawk" => :build
  depends_on "libb64" => :build
  depends_on "dcmtk"
  depends_on "suite-sparse"

  # Work around build failure when using BSD iconv (e.g. macOS Sonoma) as
  # current preprocessor condition only checks for glibc and GNU variants.
  # TODO: Report issue upstream
  patch :DATA

  def install
    ENV.append "CXX", "-std=gnu++17"

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    ENV.deparallelize if OS.mac? && MacOS.version >= :sonoma
    system "make", "install"
  end

  test do
    assert_match "usage: save2gdf [OPTIONS] SOURCE DEST", shell_output("#{bin}/save2gdf -h").strip
    assert_match "mV\t4274\t0x10b2\t0.001\tV", shell_output("#{bin}/physicalunits mV").strip
    assert_match "biosig_fhir provides fhir binary template for biosignal data",
                 shell_output("#{bin}/biosig_fhir 2>&1").strip
  end
end

__END__
diff --git a/biosig4c++/XMLParser/tinyxml.cpp b/biosig4c++/XMLParser/tinyxml.cpp
index e7f0d80..8667268 100644
--- a/biosig4c++/XMLParser/tinyxml.cpp
+++ b/biosig4c++/XMLParser/tinyxml.cpp
@@ -1120,7 +1120,7 @@ bool TiXmlDocument::LoadFile( FILE* file, TiXmlEncoding encoding )
 	}


-#if defined(_ICONV_H) || defined (_LIBICONV_H)
+#if defined(_ICONV_H) || defined (_LIBICONV_H) || defined(_ICONV_H_)
 	// convert utf-16 to utf-8 if needed

 	const char XML_UTF16LE[] = "\xff\xfe<\0?\0x\0m\0l\0 \0v\0e\0r\0s\0i\0o\0n\0=\0\"\0001\0.\0000\0\"\0 \0e\0n\0c\0o\0d\0i\0n\0g\0=\0\"\0U\0T\0F\0-\0001\0006\0\"\0?\0>\0";
diff --git a/biosig4c++/t210/sopen_axg_read.c b/biosig4c++/t210/sopen_axg_read.c
index 41796b7..34c84a6 100644
--- a/biosig4c++/t210/sopen_axg_read.c
+++ b/biosig4c++/t210/sopen_axg_read.c
@@ -394,7 +394,7 @@ if (VERBOSE_LEVEL > 7) fprintf(stdout,"%s (line %i) NS=%i nCol=%i\n", __FILE__,
 				size_t inlen      = beu32p((uint8_t*)(ValLabel[ns])-4);
 				char *outbuf      = hc->Label;
 				size_t outlen     = MAX_LENGTH_LABEL+1;
-#if  defined(_ICONV_H) || defined (_LIBICONV_H)
+#if  defined(_ICONV_H) || defined (_LIBICONV_H) || defined(_ICONV_H_)
 				iconv_t ICONV = iconv_open("UTF-8","UCS-2BE");
 				size_t reticonv = iconv(ICONV, &inbuf, &inlen, &outbuf, &outlen);
 				iconv_close(ICONV);
diff --git a/biosig4c++/t210/sopen_scp_read.c b/biosig4c++/t210/sopen_scp_read.c
index 0ffb490..e377fd6 100644
--- a/biosig4c++/t210/sopen_scp_read.c
+++ b/biosig4c++/t210/sopen_scp_read.c
@@ -365,7 +365,7 @@ int decode_scp_text(HDRTYPE *hdr, size_t inbytesleft, char *input, size_t outbyt
 		return(exitcode);
 	}

-#if  defined(_ICONV_H) || defined (_LIBICONV_H)
+#if  defined(_ICONV_H) || defined (_LIBICONV_H) || defined(_ICONV_H_)
 /*
 	decode_scp_text converts SCP text strings into UTF-8 strings
 	The table of language support code as defined in
