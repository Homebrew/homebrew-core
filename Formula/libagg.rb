class Libagg < Formula
  desc "High fidelity 2D graphics library for C++"
  homepage "http://www.antigrain.com/"
  url "http://www.antigrain.com/agg-2.5.tar.gz"
  sha256 "ab1edc54cc32ba51a62ff120d501eecd55fceeedf869b9354e7e13812289911f"

  bottle do
    cellar :any
    rebuild 1
    sha256 "97e0bd763cda63b61cefba2e46048275dda4d03cdaed251be5ebd0b7369b8e38" => :mojave
    sha256 "de1daeb1b324b1797f46ff6e6799498019de9256b4e09a128cf686e2572f6f60" => :high_sierra
    sha256 "872f49f0fd96ee65dca4bedba3e82c4fcf0e0b0c45de15afc82a9e70e0f0623c" => :sierra
    sha256 "5b9ab7a9ef2f4075bd55561f0fda99c7203a70020288747ebf90cfc1b2ee626b" => :el_capitan
    sha256 "9d3da78ab9824db755cbfeb9e6596527db1ace71525cb079465b1a9fb1c00417" => :yosemite
    sha256 "9704ec5652775cbab7af51e48eb42b19cb55f7cdb5894e6e1abac3e478581e2a" => :mavericks
    sha256 "a8519e34820cb112ca057020eda27574bec5fff386fc738d7d867a4296e8b117" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "sdl"

  # Fix build with clang; last release was in 2006
  patch :DATA

  def install
    # AM_C_PROTOTYPES was removed in automake 1.12, as it's only needed for
    # pre-ANSI compilers
    inreplace "configure.in", "AM_C_PROTOTYPES", ""
    inreplace "autogen.sh", "libtoolize", "glibtoolize"

    system "sh", "autogen.sh",
                 "--disable-dependency-tracking",
                 "--prefix=#{prefix}",
                 "--disable-platform", # Causes undefined symbols
                 "--disable-ctrl",     # No need to run these during configuration
                 "--disable-examples",
                 "--disable-sdltest"
    system "make", "install"
  end
end

__END__
diff --git a/include/agg_renderer_outline_aa.h b/include/agg_renderer_outline_aa.h
index ce25a2e..9a12d35 100644
--- a/include/agg_renderer_outline_aa.h
+++ b/include/agg_renderer_outline_aa.h
@@ -1375,7 +1375,7 @@ namespace agg
         //---------------------------------------------------------------------
         void profile(const line_profile_aa& prof) { m_profile = &prof; }
         const line_profile_aa& profile() const { return *m_profile; }
-        line_profile_aa& profile() { return *m_profile; }
+        const line_profile_aa& profile() { return *m_profile; }
 
         //---------------------------------------------------------------------
         int subpixel_width() const { return m_profile->subpixel_width(); }
