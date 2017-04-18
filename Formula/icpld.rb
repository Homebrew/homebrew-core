class Icpld < Formula
  desc "Connection monitor to track your network connection performance."
  homepage "http://www.ibiblio.org/icpld/"
  url "http://www.ibiblio.org/icpld/download/icpld-1.1.5.tar.gz"
  sha256 "9e54c33ce3b2ff2b72f5772aca02ef9f34807b5456054c328eed5b5d61b3a7c1"

  option "with-ipv6", "If you plan on using icpld with IPv6 network."
  patch :DATA

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          ("--enable-ipv6" if build.with?("ipv6"))

    system "make", "install"
  end

  test do
    system "icpld", "-v"
  end
end

__END__
diff --git a/src/fork.cpp b/src/fork.cpp
index d10eb44..ff90bf2 100644
--- a/src/fork.cpp
+++ b/src/fork.cpp
@@ -201,7 +201,7 @@ main (int argc, char *argv[])
 */
 #ifdef DARWIN 
  command = "ping -i " + pint + " -n -c 1 " + ip + " |grep \"bytes from\"";
- command2 = "ping " + " -i " + pint + " -n -c 2 " + fbip + " |grep \"bytes from\"";
+ command2 = "ping -i " + pint + " -n -c 2 " + fbip + " |grep \"bytes from\"";
 #ifdef HAVE_IPV6
   command6 = PING6;
   command6 += " -i " +  pint + " -n -c 2 " + ip6 + " |grep \"bytes from\"";
