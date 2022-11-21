class Grsync < Formula
  desc "GUI for rsync"
  homepage "https://www.opbyte.it/grsync/"
  url "https://downloads.sourceforge.net/project/grsync/grsync-1.3.0.tar.gz"
  sha256 "b7c7c6a62e05302d8317c38741e7d71ef9ab4639ee5bff2622a383b2043a35fc"
  license "GPL-2.0"

  bottle do
    sha256 arm64_ventura:  "307b9f6b438e0da05aaab7787565a059b89bc5cd3c483fb2fde1d1967de399e4"
    sha256 arm64_monterey: "082de39502badb7f49207a7b6b96a2ca985c02dddfa1aabd2955cd4d1533fd4f"
    sha256 arm64_big_sur:  "bb4de095eca6a8d58af878417ac45a713e4c955c1014c9e0d0b73238c67dbee2"
    sha256 ventura:        "1b69a87003ac96343d3169232cb0472cfc3a248e1443fdbfa9ed830a7b9355bf"
    sha256 monterey:       "c715d641af3a381a822643467956169f6ccd66486d411958ec39867548c51c59"
    sha256 big_sur:        "82f793ddc998272c4af6505feed3c5ea51c180494e193b69fb29d362a7976e52"
    sha256 catalina:       "43fbb798927566ee060d236702170c38b3eafa7cf9cdadfea323d4e52998c272"
    sha256 x86_64_linux:   "1948dee6681260c48017e6a3ba53f78776c07123665eb8111a1f463bbdf3e277"
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gtk+3"

  uses_from_macos "perl" => :build

  # Fix build with Clang.
  # https://sourceforge.net/p/grsync/code/174/
  # Remove with the next release.
  patch :DATA

  def install
    ENV.prepend_path "PERL5LIB", Formula["intltool"].libexec/"lib/perl5" unless OS.mac?

    system "./configure", "--disable-dependency-tracking",
                          "--disable-unity",
                          "--prefix=#{prefix}"
    chmod "+x", "install-sh"
    system "make", "install"
  end

  test do
    # running the executable always produces the GUI, which is undesirable for the test
    # so we'll just check if the executable exists
    assert_predicate bin/"grsync", :exist?
  end
end

__END__
--- a/src/callbacks.c
+++ b/src/callbacks.c
@@ -40,12 +40,13 @@
 gboolean more = FALSE, first = TRUE;
 
 
+void _set_label_selectable(gpointer data, gpointer user_data) {
+	GtkWidget *widget = GTK_WIDGET(data);
+	if (GTK_IS_LABEL(widget)) gtk_label_set_selectable(GTK_LABEL(widget), TRUE);
+}
+
+
 void dialog_set_labels_selectable(GtkWidget *dialog) {
-	void _set_label_selectable(gpointer data, gpointer user_data) {
-		GtkWidget *widget = GTK_WIDGET(data);
-		if (GTK_IS_LABEL(widget)) gtk_label_set_selectable(GTK_LABEL(widget), TRUE);
-	}
-
 	GtkWidget *area = gtk_message_dialog_get_message_area(GTK_MESSAGE_DIALOG(dialog));
 	GtkContainer *box = (GtkContainer *) area;
 	GList *children = gtk_container_get_children(box);
