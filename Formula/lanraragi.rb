require "language/node"

class Lanraragi < Formula
  desc "Web application for archival and reading of manga/doujinshi"
  homepage "https://github.com/Difegue/LANraragi"
  url "https://github.com/Difegue/LANraragi/archive/v.0.6.9-EX.tar.gz"
  sha256 "157a3ebdb5f132de179b69013aad351333990577bebd31e4b7b80e939b25921d"
  head "https://github.com/Difegue/LANraragi.git"

  depends_on "pkg-config" => :build
  depends_on "cpanminus"
  depends_on "giflib"
  depends_on "imagemagick@6"
  depends_on "jpeg"
  depends_on "libpng"
  depends_on "node"
  depends_on "openssl@1.1"
  depends_on "perl"
  depends_on "redis"
  uses_from_macos "libarchive"

  resource "Image::Magick" do
    url "https://cpan.metacpan.org/authors/id/J/JC/JCRISTY/PerlMagick-6.89-1.tar.gz"
    sha256 "c8f81869a4f007be63e67fddf724b23256f6209f16aa95e14d0eaef283772a59"
  end

  # libarchive headers from macOS 10.15 source
  resource "libarchive-headers-10.15" do
    url "https://opensource.apple.com/tarballs/libarchive/libarchive-72.11.2.tar.gz"
    sha256 "655b9270db794ba0b27052fd37b1750514b06769213656ab81e30727322e401f"
  end

  resource "Archive::Peek::Libarchive" do
    url "https://cpan.metacpan.org/authors/id/R/RE/REHSACK/Archive-Peek-Libarchive-0.38.tar.gz"
    sha256 "332159603c5cd560da27fd80759da84dad7d8c5b3d96fbf7586de2b264f11b70"
  end

  # Patch to remove unnecessary exports in installer and fix a bug w/ homebrew overrides
  patch :DATA

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV.prepend_path "PERL5LIB", libexec/"lib"
    ENV["CFLAGS"] = "-I"+libexec/"include"

    resource("Image::Magick").stage do
      inreplace "Makefile.PL" do |s|
        s.gsub! "include/ImageMagick-6", "opt/imagemagick@6/include/ImageMagick-6"
      end

      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    resource("libarchive-headers-10.15").stage do
      (libexec/"include").install "libarchive/libarchive/archive.h"
      (libexec/"include").install "libarchive/libarchive/archive_entry.h"
    end

    resource("Archive::Peek::Libarchive").stage do
      inreplace "Makefile.PL" do |s|
        s.gsub! "$autoconf->_get_extra_compiler_flags", "$autoconf->_get_extra_compiler_flags .$ENV{CFLAGS}"
      end

      system "cpanm", "Config::AutoConf", "-l", libexec
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    system "npm", "install", *Language::Node.local_npm_install_args
    system "perl", "./tools/install.pl", "install-full"

    prefix.install "README.md"
    bin.install "tools/build/homebrew/lanraragi"
    (libexec/"lib").install Dir["lib/*"]
    libexec.install "script"
    libexec.install "package.json"
    libexec.install "public"
    libexec.install "templates"
    libexec.install "tests"
    libexec.install "tools/build/homebrew/redis.conf"
    libexec.install "lrr.conf"
  end

  def caveats
    <<~EOS
      Automatic thumbnail generation will not work properly on macOS < 10.15 due to the bundled Libarchive being too old.
      Opening archives for reading will generate thumbnails normally.
    EOS
  end

  test do
    ENV["PERL5LIB"] = libexec/"lib/perl5"
    ENV["LRR_LOG_DIRECTORY"] = testpath/"log"

    system "npm", "--prefix", libexec, "test"
  end
end

__END__
diff --git a/lib/LANraragi/Model/Reader.pm b/lib/LANraragi/Model/Reader.pm
index 8ed2bc3..79436a8 100755
--- a/lib/LANraragi/Model/Reader.pm
+++ b/lib/LANraragi/Model/Reader.pm
@@ -135,6 +135,10 @@ sub build_reader_JSON {
 
     foreach my $imgpath (@images) {
 
+        # Strip everything before the temporary folder/id folder as to only keep the relative path to it
+        # i.e "/c/bla/lrr/temp/id/file.jpg" becomes "file.jpg"
+        $imgpath =~ s!$path/!!g;
+
         # We need to sanitize the image's path, in case the folder contains illegal characters,
         # but uri_escape would also nuke the / needed for navigation. Let's solve this with a quick regex search&replace.
         # First, we encode all HTML characters...
@@ -143,10 +147,6 @@ sub build_reader_JSON {
         # Then we bring the slashes back.
         $imgpath =~ s!%2F!/!g;
 
-        # Strip everything before the temporary folder/id folder as to only keep the relative path to it
-        # i.e "/c/bla/lrr/temp/id/file.jpg" becomes "file.jpg"
-        $imgpath =~ s!$path/!!g;
-
         # Bundle this path into an API call which will be used by the browser
         push @images_browser, "./api/page?id=$id&path=$imgpath";
     }
diff --git a/tools/install.pl b/tools/install.pl
index fb68925..e64f218 100755
--- a/tools/install.pl
+++ b/tools/install.pl
@@ -147,24 +147,18 @@ if ( $back || $full ) {
     );
     say("\r\nInstalling Perl modules... This might take a while.\r\n");
 
-    # libarchive is not provided by default on macOS, so we have to set the correct env vars
-    # to successfully compile Archive::Extract::Libarchive and Archive::Peek::Libarchive
-    my $pre = "";
-    if ($Config{"osname"} eq "darwin") {
-        say("Setting Environmental Flags for macOS");
-        $pre = "export CFLAGS=\"-I/usr/local/opt/libarchive/include\" && \\
-          export PKG_CONFIG_PATH=\"/usr/local/opt/libarchive/lib/pkgconfig\" && ";
-    } else {
+    if ( $Config{"osname"} ne "darwin" ) {
         say("Installing Linux::Inotify2 for non-macOS systems...");
         install_package("Linux::Inotify2");
     }
-    # provide cpanm with the correct module installation dir when using Homebrew
+
+    # Provide cpanm with the correct module installation dir when using Homebrew
     my $suff = "";
     if ($ENV{HOMEBREW_FORMULA_PREFIX}) {
       $suff = " -l " . $ENV{HOMEBREW_FORMULA_PREFIX} . "/libexec";
     }
 
-    if ( system($pre . "cpanm --installdeps ./tools/. --notest" . $suff) != 0 ) {
+    if ( system("cpanm --installdeps ./tools/. --notest" . $suff) != 0 ) {
         die "Something went wrong while installing Perl modules - Bailing out.";
     }
 }
