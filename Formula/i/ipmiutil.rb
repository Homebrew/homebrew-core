class Ipmiutil < Formula
  desc "IPMI server management utility"
  homepage "https://ipmiutil.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ipmiutil/ipmiutil-3.1.9.tar.gz"
  sha256 "5ae99bdd1296a8e25cea839784ec39ebca57b0e3701b2d440b8e02e22dc4bc95"
  license all_of: ["BSD-2-Clause", "BSD-3-Clause", "GPL-2.0-or-later"]

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cae2294a98966889ce7158ab6506ed7b1f87e6d981bff197e8c8a34c9f6ea9c3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "25a7bf60f294710207ada5b75c6cbbc0e7a5762ff06199151d676816dc9dd384"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "07ad84d82b2d7b16e484b81b8057e10911a82c880b9516dcad3b7e564028b6b4"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a79a69b51f5ea2e478d2b912900e6713eb91d7006b0e9ec73d597efcf4b81fe"
    sha256 cellar: :any_skip_relocation, ventura:       "9d83f92e6b0c65b464c3cdaae66d13d7995fc875a76069180078758a1819048a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1a68d7956c2c4f06a13bd4ba7d67a05e3ca5e771030463db32b49d7426a0fdfc"
  end

  on_macos do
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  conflicts_with "renameutils", because: "both install `icmd` binaries"

  # add upstream build patch, upstream bug report, https://sourceforge.net/p/ipmiutil/support-requests/61/
  patch :DATA

  def install
    # Workaround for newer Clang
    ENV.append "CC", "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    # Darwin does not exist only on PowerPC
    if OS.mac?
      inreplace "configure.ac", "test \"$archp\" = \"powerpc\"", "true"
      system "autoreconf", "--force", "--install", "--verbose"
    end

    system "./configure", *std_configure_args,
                          "--disable-silent-rules",
                          "--disable-lanplus",
                          "--enable-sha256",
                          "--enable-gpl"

    system "make", "TMPDIR=#{ENV["TMPDIR"]}"
    # DESTDIR is needed to make everything go where we want it.
    system "make", "prefix=/",
                   "DESTDIR=#{prefix}",
                   "varto=#{var}/lib/#{name}",
                   "initto=#{etc}/init.d",
                   "sysdto=#{prefix}/#{name}",
                   "install"
  end

  test do
    system bin/"ipmiutil", "delloem", "help"
  end
end

__END__
diff --git a/util/oem_dell.c b/util/oem_dell.c
index b474ee3..b4d8112 100644
--- a/util/oem_dell.c
+++ b/util/oem_dell.c
@@ -4,6 +4,7 @@
  *
  * Change history:
  *  08/17/2011 ARCress - included in ipmiutil source tree
+ *  09/18/2024 ARCress - fix macos compile error with vFlashstr
  *
  */
 /******************************************************************
@@ -157,8 +158,14 @@ static uint8_t SetLEDSupported=0;
 
 volatile uint8_t IMC_Type = IMC_IDRAC_10G;
 
+typedef struct
+{
+    int val;
+    char *str;
+} vFlashstr;
 
-const struct vFlashstr vFlash_completion_code_vals[] = {
+// const struct vFlashstr vFlash_completion_code_vals[] = {
+const vFlashstr  vFlash_completion_code_vals[] = {
 	{0x00, "SUCCESS"},
 	{0x01, "NO_SD_CARD"},
 	{0x63, "UNKNOWN_ERROR"},
@@ -250,7 +257,8 @@ static void ipmi_powermonitor_usage(void);
 
 /* vFlash Function prototypes */
 static int ipmi_delloem_vFlash_main(void * intf, int  argc, char ** argv);
-const char * get_vFlash_compcode_str(uint8_t vflashcompcode, const struct vFlashstr *vs);
+// const char * get_vFlash_compcode_str(uint8_t vflashcompcode, const struct vFlashstr *vs);
+const char * get_vFlash_compcode_str(uint8_t vflashcompcode, const vFlashstr *vs);
 static int ipmi_get_sd_card_info(void* intf);
 static int ipmi_delloem_vFlash_process(void* intf, int current_arg, char ** argv);
 static void ipmi_vFlash_usage(void);
@@ -4818,7 +4826,7 @@ static int ipmi_delloem_vFlash_main (void * intf, int  argc, char ** argv)
 *
 ******************************************************************/
 const char * 
-get_vFlash_compcode_str(uint8_t vflashcompcode, const struct vFlashstr *vs)
+get_vFlash_compcode_str(uint8_t vflashcompcode, const vFlashstr *vs)
 {
 	static char un_str[32];
 	int i;
