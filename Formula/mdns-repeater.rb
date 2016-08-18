class MdnsRepeater < Formula
  desc "Multicast DNS repeater"
  homepage "https://bitbucket.org/geekman/mdns-repeater"
  url "https://bitbucket.org/geekman/mdns-repeater/get/28ecc2ab9a0e.zip"
  version "1.10"
  sha256 "978e021ecd4ba21c8258d457380d8fec09a221de51dfc42c9a0c5d472fefdc64"

  # Patches:
  # 1. Patch to the Makefile to remove dependency on mercurial for versioning
  # 2. Modifications to compile and function correctly under OS X
  patch :DATA

  def install
    system "make", "HGVERSION=#{version}"
    bin.install "mdns-repeater"
    doc.install "README.txt", "LICENSE.txt"
  end

  test do
    system bin/"mdns-repeater", "-h"
  end
end

__END__
diff -r 28ecc2ab9a0e Makefile
--- a/Makefile	Wed Sep 21 21:50:06 2011 +0800
+++ b/Makefile	Thu Aug 18 16:21:08 2016 -0400
@@ -7,8 +7,6 @@
 			README.txt		\
 			LICENSE.txt
 
-HGVERSION=$(shell hg parents --template "{latesttag}.{latesttagdistance}")
-
 CFLAGS=-Wall
 
 ifdef DEBUG
diff -r 28ecc2ab9a0e mdns-repeater.c
--- a/mdns-repeater.c	Wed Sep 21 21:50:06 2011 +0800
+++ b/mdns-repeater.c	Thu Aug 18 16:21:08 2016 -0400
@@ -32,6 +32,7 @@
 #include <netinet/in.h>
 #include <arpa/inet.h>
 #include <net/if.h>
+#include <errno.h>
 
 #define PACKAGE "mdns-repeater"
 #define MDNS_ADDR "224.0.0.251"
@@ -79,7 +80,7 @@
 static int create_recv_sock() {
 	int sd = socket(AF_INET, SOCK_DGRAM, 0);
 	if (sd < 0) {
-		log_message(LOG_ERR, "recv socket(): %m");
+		log_message(LOG_ERR, "recv socket(): %s", strerror(errno));
 		return sd;
 	}
 
@@ -87,10 +88,17 @@
 
 	int on = 1;
 	if ((r = setsockopt(sd, SOL_SOCKET, SO_REUSEADDR, &on, sizeof(on))) < 0) {
-		log_message(LOG_ERR, "recv setsockopt(SO_REUSEADDR): %m");
+		log_message(LOG_ERR, "recv setsockopt(SO_REUSEADDR): %s", strerror(errno));
 		return r;
 	}
 
+#ifdef SO_REUSEPORT
+	if ((r = setsockopt(sd, SOL_SOCKET, SO_REUSEPORT, &on, sizeof(on))) < 0) {
+		log_message(LOG_ERR, "recv setsockopt(SO_REUSEPORT): %s", strerror(errno));
+		return r;
+	}
+#endif
+
 	/* bind to an address */
 	struct sockaddr_in serveraddr;
 	memset(&serveraddr, 0, sizeof(serveraddr));
@@ -98,18 +106,19 @@
 	serveraddr.sin_port = htons(MDNS_PORT);
 	serveraddr.sin_addr.s_addr = htonl(INADDR_ANY);	/* receive multicast */
 	if ((r = bind(sd, (struct sockaddr *)&serveraddr, sizeof(serveraddr))) < 0) {
-		log_message(LOG_ERR, "recv bind(): %m");
+		log_message(LOG_ERR, "recv bind(): %s", strerror(errno));
+		return r;
 	}
 
 	// enable loopback in case someone else needs the data
 	if ((r = setsockopt(sd, IPPROTO_IP, IP_MULTICAST_LOOP, &on, sizeof(on))) < 0) {
-		log_message(LOG_ERR, "recv setsockopt(IP_MULTICAST_LOOP): %m");
+		log_message(LOG_ERR, "recv setsockopt(IP_MULTICAST_LOOP): %s", strerror(errno));
 		return r;
 	}
 
-#ifdef IP_PKTINFO
-	if ((r = setsockopt(sd, SOL_IP, IP_PKTINFO, &on, sizeof(on))) < 0) {
-		log_message(LOG_ERR, "recv setsockopt(IP_PKTINFO): %m");
+#ifdef IP_RECVDSTADDR
+	if ((r = setsockopt(sd, IPPROTO_IP, IP_RECVDSTADDR, &on, sizeof(on))) < 0) {
+		log_message(LOG_ERR, "recv setsockopt(IP_RECVDSTADDR): %s", strerror(errno));
 		return r;
 	}
 #endif
@@ -120,7 +129,7 @@
 static int create_send_sock(int recv_sockfd, const char *ifname, struct if_sock *sockdata) {
 	int sd = socket(AF_INET, SOCK_DGRAM, 0);
 	if (sd < 0) {
-		log_message(LOG_ERR, "send socket(): %m");
+		log_message(LOG_ERR, "send socket(): %s", strerror(errno));
 		return sd;
 	}
 
@@ -136,7 +145,7 @@
 
 #ifdef SO_BINDTODEVICE
 	if ((r = setsockopt(sd, SOL_SOCKET, SO_BINDTODEVICE, &ifr, sizeof(struct ifreq))) < 0) {
-		log_message(LOG_ERR, "send setsockopt(SO_BINDTODEVICE): %m");
+		log_message(LOG_ERR, "send setsockopt(SO_BINDTODEVICE): %s", strerror(errno));
 		return r;
 	}
 #endif
@@ -156,7 +165,7 @@
 
 	int on = 1;
 	if ((r = setsockopt(sd, SOL_SOCKET, SO_REUSEADDR, &on, sizeof(on))) < 0) {
-		log_message(LOG_ERR, "send setsockopt(SO_REUSEADDR): %m");
+		log_message(LOG_ERR, "send setsockopt(SO_REUSEADDR): %s", strerror(errno));
 		return r;
 	}
 
@@ -167,22 +176,28 @@
 	serveraddr.sin_port = htons(MDNS_PORT);
 	serveraddr.sin_addr.s_addr = if_addr->s_addr;
 	if ((r = bind(sd, (struct sockaddr *)&serveraddr, sizeof(serveraddr))) < 0) {
-		log_message(LOG_ERR, "send bind(): %m");
+		log_message(LOG_ERR, "send bind(): %s", strerror(errno));
 	}
 
+#if __APPLE__
+	if((r = setsockopt(sd, IPPROTO_IP, IP_MULTICAST_IF, &serveraddr.sin_addr, sizeof(serveraddr.sin_addr))) < 0) {
+		log_message(LOG_ERR, "send ip_multicast_if(): errno %d: %s", errno, strerror(errno));
+	}
+#endif
+
 	// add membership to receiving socket
 	struct ip_mreq mreq;
 	memset(&mreq, 0, sizeof(struct ip_mreq));
 	mreq.imr_interface.s_addr = if_addr->s_addr;
 	mreq.imr_multiaddr.s_addr = inet_addr(MDNS_ADDR);
 	if ((r = setsockopt(recv_sockfd, IPPROTO_IP, IP_ADD_MEMBERSHIP, &mreq, sizeof(mreq))) < 0) {
-		log_message(LOG_ERR, "recv setsockopt(IP_ADD_MEMBERSHIP): %m");
+		log_message(LOG_ERR, "recv setsockopt(IP_ADD_MEMBERSHIP): %s", strerror(errno));
 		return r;
 	}
 
 	// enable loopback in case someone else needs the data
 	if ((r = setsockopt(sd, IPPROTO_IP, IP_MULTICAST_LOOP, &on, sizeof(on))) < 0) {
-		log_message(LOG_ERR, "send setsockopt(IP_MULTICAST_LOOP): %m");
+		log_message(LOG_ERR, "send setsockopt(IP_MULTICAST_LOOP): %s", strerror(errno));
 		return r;
 	}
 
@@ -249,7 +264,7 @@
 	pid_t running_pid;
 	pid_t pid = fork();
 	if (pid < 0) {
-		log_message(LOG_ERR, "fork(): %m");
+		log_message(LOG_ERR, "fork(): %s", strerror(errno));
 		exit(1);
 	}
 
@@ -385,7 +400,7 @@
 
 	pkt_data = malloc(PACKET_SIZE);
 	if (pkt_data == NULL) {
-		log_message(LOG_ERR, "cannot malloc() packet buffer: %m");
+		log_message(LOG_ERR, "cannot malloc() packet buffer: %s", strerror(errno));
 		r = 1;
 		goto end_main;
 	}
@@ -409,7 +424,7 @@
 			ssize_t recvsize = recvfrom(server_sockfd, pkt_data, PACKET_SIZE, 0, 
 				(struct sockaddr *) &fromaddr, &sockaddr_size);
 			if (recvsize < 0) {
-				log_message(LOG_ERR, "recv(): %m");
+				log_message(LOG_ERR, "recv(): %s", strerror(errno));
 			}
 
 			int j;
@@ -440,7 +455,7 @@
 				ssize_t sentsize = send_packet(socks[j].sockfd, pkt_data, (size_t) recvsize);
 				if (sentsize != recvsize) {
 					if (sentsize < 0)
-						log_message(LOG_ERR, "send()");
+						log_message(LOG_ERR, "send(): %s", strerror(errno));
 					else
 						log_message(LOG_ERR, "send_packet size differs: sent=%ld actual=%ld",
 							recvsize, sentsize);
