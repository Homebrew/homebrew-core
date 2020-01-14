class Alpine < Formula
  desc "News and email agent"
  homepage "https://repo.or.cz/alpine.git"
  url "https://repo.or.cz/alpine.git/snapshot/v2.21.99999.tar.gz"
  sha256 "6b27da784b8c1dd5bc2553cb04e622ac4461d58409a178b7c83541cd167451d0"
  head "https://repo.or.cz/alpine.git"

  depends_on "openssl@1.1"

  patch :DATA

  def install
    ENV.deparallelize

    args = %W[
      --disable-debug
      --with-ssl-dir=#{Formula["openssl@1.1"].opt_prefix}
      --with-ssl-certs-dir=#{etc}/openssl@1.1
      --prefix=#{prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/alpine", "-supported"
  end
end
__END__
diff --git a/alpine/imap.c b/alpine/imap.c
index 0a2a82a..95081f4 100644
--- a/alpine/imap.c
+++ b/alpine/imap.c
@@ -591,6 +591,7 @@ mm_login_oauth2(NETMBX *mb, char *user, OAUTH2_S *login, long int trial,
 		      altuserforcache ? altuserforcache : user, hostlist,
 		      (mb->sslflag||mb->tlsflag), 0, 0, OA2NAME);
 #ifdef	LOCAL_PASSWD_CACHE
+#ifdef	PASSFILE
     /* if requested, remember it on disk for next session */
     if(save_password && F_OFF(F_DISABLE_PASSWORD_FILE_SAVING,ps_global))
 	    set_passfile_passwd_auth(ps_global->pinerc, token,
@@ -598,6 +599,7 @@ mm_login_oauth2(NETMBX *mb, char *user, OAUTH2_S *login, long int trial,
 			(mb->sslflag||mb->tlsflag),
 			(preserve_password == -1 ? 0
 			 : (preserve_password == 0 ? 2 :1)), OA2NAME);
+#endif	/* PASSFILE */
 #endif	/* LOCAL_PASSWD_CACHE */

     ps_global->no_newmail_check_from_optionally_enter = 0;
@@ -1495,6 +1497,7 @@ mm_login_work(NETMBX *mb, char *user, char **pwd, long int trial,
 		      altuserforcache ? altuserforcache : user, hostlist,
 		      (mb->sslflag||mb->tlsflag), 0, 0);
 #ifdef	LOCAL_PASSWD_CACHE
+#ifdef  PASSFILE
     /* if requested, remember it on disk for next session */
       if(save_password && F_OFF(F_DISABLE_PASSWORD_FILE_SAVING,ps_global))
       set_passfile_passwd(ps_global->pinerc, *pwd,
@@ -1502,6 +1505,7 @@ mm_login_work(NETMBX *mb, char *user, char **pwd, long int trial,
 			(mb->sslflag||mb->tlsflag),
 			(preserve_password == -1 ? 0
 			 : (preserve_password == 0 ? 2 :1)));
+#endif	/* PASSFILE */
 #endif	/* LOCAL_PASSWD_CACHE */

     ps_global->no_newmail_check_from_optionally_enter = 0;
