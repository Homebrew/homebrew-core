class GtkSharp < Formula
  desc "Graphical User Interface Toolkit for mono and .Net"
  homepage "http://www.mono-project.com/GtkSharp"
  url "https://download.mono-project.com/sources/gtk-sharp212/gtk-sharp-2.12.45.tar.gz"
  sha256 "02680578e4535441064aac21d33315daa009d742cab8098ac8b2749d86fffb6a"

  depends_on "pango"
  depends_on "atk"
  depends_on "gtk+"
  depends_on "libglade"
  depends_on "mono"

  def install
    args = ["--prefix=#{prefix}",
            "--disable-debug",
            "--disable-dependency-tracking"]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.cs").write <<-EOS.undent
      using System;
      using Gtk;

      public class GtkHelloWorld {

        public static void Main() {
          Console.WriteLine("HelloWorld");
        }

      }
    EOS
    system "mcs", "-pkg:gtk-sharp-2.0", "test.cs"
    system "mono", "./test.exe"
  end
end
