class Grsync < Formula
  desc "GUI for rsync"
  homepage "https://www.opbyte.it/grsync/"
  url "https://downloads.sourceforge.net/project/grsync/grsync-1.3.0.tar.gz"
  sha256 "b7c7c6a62e05302d8317c38741e7d71ef9ab4639ee5bff2622a383b2043a35fc"
  license "GPL-2.0"

  bottle do
    sha256 arm64_monterey: "3bea8e3c2c4cf7cc80114866420b4fbbf4155d84fa230e6a5f3bd5f484a80032"
    sha256 arm64_big_sur:  "55955b7e18bcb06ad62fa0bca9102901b15b47ae9ea5f69324b987db553cb929"
    sha256 monterey:       "40f70235563cec32800bf0ce720038532397505ce9c05c434cc6a3f9a97ee395"
    sha256 big_sur:        "e5a84736533563fda92cc9173a70b6fed4dd450f75b6280734d069a6e1609139"
    sha256 catalina:       "07f40176b0bfb08d3b461fceb2d4e18f249354ef60a57dd550c11c31d26fee6a"
    sha256 mojave:         "b0bf1fe191950905e46c81953e93a72c6c6c185c146b1a79d09e388348e1c5f1"
    sha256 high_sierra:    "741b7306a6373fc2d86a416a2def2a06c1fd25ab6b30585755faa8326c497c2b"
    sha256 x86_64_linux:   "ce94b087a3540ee9e441ace3289db2ff586ead5bf00321e3f31d6cc9a368543d"
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
