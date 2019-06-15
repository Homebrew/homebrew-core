class Onedrive < Formula
  desc "Folder synchronization with OneDrive"
  homepage "https://github.com/abraunegg/onedrive"
  url "https://github.com/abraunegg/onedrive/archive/v2.3.4.tar.gz"
  sha256 "3af9f16f4cbb0435e14bbbb0f7b619d30414604dea9b2b866c04a18951d170d2"

  depends_on "ldc" => :build
  depends_on "pkg-config" => :build
  depends_on "curl-openssl"
  depends_on "sqlite"

  patch :DATA

  def install
    ENV["DC"] = "ldc2"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    bash_completion.install "contrib/completions/complete.bash"
    zsh_completion.install "contrib/completions/complete.zsh" => "_onedrive"
  end

  test do
    system "#{bin}/onedrive", "--version"
  end
end

__END__
diff --git a/Makefile.in b/Makefile.in
index 7399641..5c6d3e1 100644
--- a/Makefile.in
+++ b/Makefile.in
@@ -100,14 +100,13 @@ onedrive: version $(SOURCES)
 	$(DC) $(DCFLAGS) $(addprefix -L,$(curl_LIBS)) $(addprefix -L,$(sqlite_LIBS)) $(addprefix -L,$(notify_LIBS)) -L-ldl $(SOURCES) -of$@
 
 install: all
-	$(INSTALL) -d -o root -g users -m 0775 $(DESTDIR)/var/log/onedrive
 	$(INSTALL) -D onedrive $(DESTDIR)$(bindir)/onedrive
 	$(INSTALL) -D onedrive.1 $(DESTDIR)$(mandir)/man1/onedrive.1
 	$(INSTALL) -D -m 644 contrib/logrotate/onedrive.logrotate $(DESTDIR)$(sysconfdir)/logrotate.d/onedrive
 	mkdir -p $(DESTDIR)$(docdir)
 	$(INSTALL) -D -m 644 $(DOCFILES) $(DESTDIR)$(docdir)
 ifeq ($(HAVE_SYSTEMD),yes)
-	$(INSTALL) -d -o root -g root -m 0755 $(DESTDIR)$(systemduserunitdir) $(DESTDIR)$(systemdsystemunitdir)
+	$(INSTALL) -d -m 0755 $(DESTDIR)$(systemduserunitdir) $(DESTDIR)$(systemdsystemunitdir)
 ifeq ($(RHEL),1)
 	$(INSTALL) -m 0644 $(system_unit_files) $(DESTDIR)$(systemdsystemunitdir)
 	$(INSTALL) -m 0644 $(user_unit_files) $(DESTDIR)$(systemdsystemunitdir)
diff --git a/docs/USAGE.md b/docs/USAGE.md
index 1b6546b..f47e545 100644
--- a/docs/USAGE.md
+++ b/docs/USAGE.md
@@ -134,13 +134,20 @@ onedrive --synchronize --verbose
 ### Client Activity Log
 When running onedrive all actions can be logged to a separate log file. This can be enabled by using the `--enable-logging` flag. By default, log files will be written to `/var/log/onedrive/`
 
-**Note:** You will need to ensure your user has the applicable permissions to write to this directory or the following warning will be printed:
+**Note:** You will need to ensure the existence of this directory, and that your user has the applicable permissions to write to this directory or the following warning will be printed:
 ```text
 Unable to access /var/log/onedrive/
 Please manually create '/var/log/onedrive/' and set appropriate permissions to allow write access
 The requested client activity log will instead be located in the users home directory
 ```
 
+On many systems this can be achieved by
+```text
+mkdir /var/log/onedrive
+chown root.users /var/log/onedrive
+chmod 0775 /var/log/onedrive
+```
+
 All logfiles will be in the format of `%username%.onedrive.log`, where `%username%` represents the user who ran the client.
 
 **Note:**
