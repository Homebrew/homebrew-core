class Openldap < Formula
  desc "Open source suite of directory software"
  homepage "https://www.openldap.org/software/"
  url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/openldap-2.6.13.tgz"
  mirror "http://fresh-center.net/linux/misc/openldap-2.6.13.tgz"
  mirror "http://fresh-center.net/linux/misc/legacy/openldap-2.6.13.tgz"
  sha256 "d693b49517a42efb85a1a364a310aed16a53d428d1b46c0d31ef3fba78fcb656"
  license "OLDAP-2.8"
  revision 1
  compatibility_version 1

  livecheck do
    url "https://www.openldap.org/software/download/OpenLDAP/openldap-release/"
    regex(/href=.*?openldap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_tahoe:   "ef9407dd935649ca7d1dd53b086e72936eff0402b190eee6375a5b8ffcb1ee0d"
    sha256 arm64_sequoia: "d61761c4029277ef337a1bbb7f14e7d681dce1bd493c90a00ea9e22909741ecd"
    sha256 arm64_sonoma:  "f1008c1cd0133a3954547eed73863dd1fd34e4fbdfad08d0de2581b688d9cc52"
    sha256 sonoma:        "80ce4d562ec30e93563e7df3de3a9a0acbcebc96b1de601500a5e670063f2b30"
    sha256 arm64_linux:   "9029df3d610eb3eacd728432431dd41537d059ed2dde09cbe553b663df02f13b"
    sha256 x86_64_linux:  "b1be6097fd7b3a7d36452440233d1e066218b6f88bb0cf6770a5bea65656272f"
  end

  keg_only :provided_by_macos

  depends_on "openssl@4"

  uses_from_macos "mandoc" => :build
  uses_from_macos "cyrus-sasl"

  on_linux do
    depends_on "util-linux"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  # OpenSSL 4 makes ASN1_STRING opaque.
  patch :DATA

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --enable-accesslog
      --enable-auditlog
      --enable-bdb=no
      --enable-constraint
      --enable-dds
      --enable-deref
      --enable-dyngroup
      --enable-dynlist
      --enable-hdb=no
      --enable-memberof
      --enable-ppolicy
      --enable-proxycache
      --enable-refint
      --enable-retcode
      --enable-seqmod
      --enable-sssvlv
      --enable-translucent
      --enable-unique
      --enable-valsort
      --with-cyrus-sasl
      --without-systemd
    ]

    soelim = if OS.mac?
      if MacOS.version >= :ventura
        "mandoc_soelim"
      else
        "soelim"
      end
    else
      "bsdsoelim"
    end

    system "./configure", *args
    system "make", "install", "SOELIM=#{soelim}"
    (var/"run").mkpath

    # https://github.com/Homebrew/homebrew-dupes/pull/452
    chmod 0755, etc.glob("openldap/*")
    chmod 0755, etc.glob("openldap/schema/*")

    # Don't embed Cellar references in files installed in `etc`.
    # Passing `build.bottle?` ensures that inreplace failures result in build failures
    # only when building a bottle. This helps avoid problems for users who build from source
    # and may have an old version of these files in `etc`.
    inreplace etc.glob("openldap/slapd.{conf,ldif}"), prefix, opt_prefix, audit_result: build.bottle?
  end

  test do
    system sbin/"slappasswd", "-s", "test"
  end
end

__END__
diff --git a/libraries/libldap/tls_o.c b/libraries/libldap/tls_o.c
index 1765a6d..9f55fe0 100644
--- a/libraries/libldap/tls_o.c
+++ b/libraries/libldap/tls_o.c
@@ -975,6 +975,8 @@ tlso_session_chkhost( LDAP *ld, tls_session *sess, const char *name_in )
 		ASN1_OBJECT *obj;
 		ASN1_STRING *cn = NULL;
 		int navas;
+		const unsigned char *cn_data;
+		int cn_len;
 
 		/* find the last CN */
 		obj = OBJ_nid2obj( NID_commonName );
@@ -999,35 +1001,41 @@ no_cn:
 			ld->ld_error = LDAP_STRDUP(
 				_("TLS: unable to get CN from peer certificate"));
 
-		} else if ( cn->length == nlen &&
-			strncasecmp( name, (char *) cn->data, nlen ) == 0 ) {
-			ret = LDAP_SUCCESS;
+		} else {
+			cn_data = ASN1_STRING_get0_data( cn );
+			cn_len = ASN1_STRING_length( cn );
 
-		} else if (( cn->data[0] == '*' ) && ( cn->data[1] == '.' )) {
-			char *domain = strchr(name, '.');
-			if( domain ) {
-				int dlen;
+			if ( cn_data && cn_len == nlen &&
+				strncasecmp( name, (const char *) cn_data, nlen ) == 0 ) {
+				ret = LDAP_SUCCESS;
 
-				dlen = nlen - (domain-name);
+			} else if ( cn_data && cn_len > 1 &&
+				( cn_data[0] == '*' ) && ( cn_data[1] == '.' )) {
+				char *domain = strchr(name, '.');
+				if( domain ) {
+					int dlen;
 
-				/* Is this a wildcard match? */
-				if ((dlen == cn->length-1) &&
-					!strncasecmp(domain, (char *) &cn->data[1], dlen)) {
-					ret = LDAP_SUCCESS;
+					dlen = nlen - (domain-name);
+
+					/* Is this a wildcard match? */
+					if ((dlen == cn_len-1) &&
+						!strncasecmp(domain, (const char *) &cn_data[1], dlen)) {
+						ret = LDAP_SUCCESS;
+					}
 				}
 			}
-		}
 
-		if( ret == LDAP_LOCAL_ERROR ) {
-			Debug3( LDAP_DEBUG_ANY, "TLS: hostname (%s) does not match "
-				"common name in certificate (%.*s).\n", 
-				name, cn->length, cn->data );
-			ret = LDAP_CONNECT_ERROR;
-			if ( ld->ld_error ) {
-				LDAP_FREE( ld->ld_error );
+			if( ret == LDAP_LOCAL_ERROR ) {
+				Debug3( LDAP_DEBUG_ANY, "TLS: hostname (%s) does not match "
+					"common name in certificate (%.*s).\n", 
+					name, cn_len, cn_data ? (char *) cn_data : "" );
+				ret = LDAP_CONNECT_ERROR;
+				if ( ld->ld_error ) {
+					LDAP_FREE( ld->ld_error );
+				}
+				ld->ld_error = LDAP_STRDUP(
+					_("TLS: hostname does not match name in peer certificate"));
 			}
-			ld->ld_error = LDAP_STRDUP(
-				_("TLS: hostname does not match name in peer certificate"));
 		}
 	}
 done:
