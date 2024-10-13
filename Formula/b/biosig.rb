class Biosig < Formula
  desc "Tools for biomedical signal processing and data conversion"
  homepage "https://biosig.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/biosig/BioSig%20for%20C_C%2B%2B/src/biosig-2.6.1.src.tar.xz"
  sha256 "558ee17cd7b4aa1547e98e52bb85cccccb7f7a81600f9bef3a50cd5b34d0729e"
  license "GPL-3.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/(?:biosig|biosig4c[^-]*?)[._-]v?(\d+(?:\.\d+)+)\.src\.t}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "237a918401c7b500c93ee2a07262c7394965f3c8515bb445e0a1b49d6f096e3e"
    sha256 cellar: :any,                 arm64_sonoma:   "94ce1ed94f2e62d54961a2a711af52a9f229b7852f535ee1ce9a2248576cee83"
    sha256 cellar: :any,                 arm64_ventura:  "a88421331309918094ee177f00e8b6537ba8d6125a5507d73183275d770e372d"
    sha256 cellar: :any,                 arm64_monterey: "a94537bf985066694053ddcfe3a8254457ea0a9ed6acc4180da825dddb5a6537"
    sha256 cellar: :any,                 sonoma:         "832caf6d00dd2a716f4bcbded968ae70552e807e90b68ceba5b590207555d1f1"
    sha256 cellar: :any,                 ventura:        "6a3926692abe3a19947778b679542669ea010075620ddbcb62240ff411e35026"
    sha256 cellar: :any,                 monterey:       "5136c7261264acb7dd2631527165f52074587979d988f09c9d551b94cdc48586"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "971e1c4a42c02b0d7bdcceea087f94f3d66314718f319108dcc019717beb0f78"
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
