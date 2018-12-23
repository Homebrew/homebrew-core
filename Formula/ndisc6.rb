class Ndisc6 < Formula
  desc "Small collection of useful tools for IPv6 networking"
  homepage "https://www.remlab.net/ndisc6/"
  url "https://www.remlab.net/files/ndisc6/ndisc6-1.0.3.tar.bz2"
  sha256 "0f41d6caf5f2edc1a12924956ae8b1d372e3b426bd7b11eed7d38bc974eec821"

  depends_on "gcc" => :build
  depends_on "gcc"

  fails_with :clang do
    build 1000
    cause "Compilation errors, including use of variable length array in structure"
  end

  # Patches needed to fix compilation errors on macOS.
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/addr2name", "--version"
    system "#{bin}/name2addr", "--version"
    system "#{bin}/ndisc6", "--version"
    system "#{bin}/rdisc6", "--version"
    system "#{bin}/rltraceroute6", "--version"
    system "#{bin}/tcpspray", "--version"
    system "#{bin}/tcpspray6", "--version"
    system "#{bin}/tcptraceroute6", "--version"
    system "#{bin}/tracert6", "--version"
    system "#{sbin}/rdnssd", "--version"
  end
end

__END__
diff --recursive --unified a/rdnssd/icmp.c b/rdnssd/icmp.c
--- a/rdnssd/icmp.c	2011-09-22 08:59:47.000000000 -0700
+++ b/rdnssd/icmp.c	2018-12-22 18:15:30.000000000 -0800
@@ -34,7 +34,7 @@
 
 #ifndef IPV6_RECVHOPLIMIT
 # warning using RFC2922 instead of RFC3542
-# define IPV6_RECVHOPLIMIT IPV6_HOPLIMIT
+# define IPV6_RECVHOPLIMIT IPV6_2292HOPLIMIT
 #endif
 
 #ifndef SOL_IPV6
@@ -78,7 +78,7 @@
 		     cmsg = CMSG_NXTHDR (&msg, cmsg))
 		{
 			if ((cmsg->cmsg_level == IPPROTO_IPV6)
-			 && (cmsg->cmsg_type == IPV6_HOPLIMIT)
+			 && (cmsg->cmsg_type == IPV6_2292HOPLIMIT)
 			 && (255 != *(int *)CMSG_DATA (cmsg)))  /* illegal hop limit */
 				return -1;
 		}
diff --recursive --unified a/rdnssd/rdnssd.h b/rdnssd/rdnssd.h
--- a/rdnssd/rdnssd.h	2011-10-17 08:35:11.000000000 -0700
+++ b/rdnssd/rdnssd.h	2018-12-22 18:25:06.000000000 -0800
@@ -32,24 +32,6 @@
 #define ND_OPT_RDNSS 25
 #define ND_OPT_DNSSL 31
 
-struct nd_opt_rdnss
-{
-	uint8_t nd_opt_rdnss_type;
-	uint8_t nd_opt_rdnss_len;
-	uint16_t nd_opt_rdnss_reserved;
-	uint32_t nd_opt_rdnss_lifetime;
-	/* followed by one or more IPv6 addresses */
-};
-
-struct nd_opt_dnssl
-{
-	uint8_t nd_opt_dnssl_type;
-	uint8_t nd_opt_dnssl_len;
-	uint16_t nd_opt_dnssl_reserved;
-	uint32_t nd_opt_dnssl_lifetime;
-	/* followed by one or more domain names */
-};
-
 # ifdef __cplusplus
 extern "C" {
 # endif
diff --recursive --unified a/src/ndisc.c b/src/ndisc.c
--- a/src/ndisc.c	2014-12-14 02:39:28.000000000 -0800
+++ b/src/ndisc.c	2018-12-22 18:07:52.000000000 -0800
@@ -60,7 +60,7 @@
 
 #ifndef IPV6_RECVHOPLIMIT
 /* Using obsolete RFC 2292 instead of RFC 3542 */ 
-# define IPV6_RECVHOPLIMIT IPV6_HOPLIMIT
+# define IPV6_RECVHOPLIMIT IPV6_2292HOPLIMIT
 #endif
 
 /* BSD-like systems define ND_RA_FLAG_HA instead of ND_RA_FLAG_HOME_AGENT */
@@ -653,7 +653,7 @@
 	     cmsg = CMSG_NXTHDR (&hdr, cmsg))
 	{
 		if ((cmsg->cmsg_level == IPPROTO_IPV6)
-		 && (cmsg->cmsg_type == IPV6_HOPLIMIT))
+		 && (cmsg->cmsg_type == IPV6_2292HOPLIMIT))
 		{
 			if (255 != *(int *)CMSG_DATA (cmsg))
 			{
diff --recursive --unified a/src/traceroute.c b/src/traceroute.c
--- a/src/traceroute.c	2014-12-14 02:04:35.000000000 -0800
+++ b/src/traceroute.c	2018-12-22 18:08:45.000000000 -0800
@@ -72,7 +72,7 @@
 
 #ifndef IPV6_RECVHOPLIMIT
 /* Using obsolete RFC 2292 instead of RFC 3542 */
-# define IPV6_RECVHOPLIMIT IPV6_HOPLIMIT
+# define IPV6_RECVHOPLIMIT IPV6_2292HOPLIMIT
 #endif
 
 #ifndef ICMP6_DST_UNREACH_BEYONDSCOPE
@@ -130,7 +130,7 @@
 
 	struct cmsghdr *cmsg = CMSG_FIRSTHDR (&hdr);
 	cmsg->cmsg_level = IPPROTO_IPV6;
-	cmsg->cmsg_type = IPV6_HOPLIMIT;
+	cmsg->cmsg_type = IPV6_2292HOPLIMIT;
 	cmsg->cmsg_len = CMSG_LEN (sizeof (hlim));
 
 	memcpy (CMSG_DATA (cmsg), &hlim, sizeof (hlim));
@@ -174,7 +174,7 @@
 	     cmsg != NULL;
 	     cmsg = CMSG_NXTHDR (&hdr, cmsg))
 		if ((cmsg->cmsg_level == IPPROTO_IPV6)
-		 && (cmsg->cmsg_type == IPV6_HOPLIMIT))
+		 && (cmsg->cmsg_type == IPV6_2292HOPLIMIT))
 			memcpy (hlim, CMSG_DATA (cmsg), sizeof (*hlim));
 
 	return val;
