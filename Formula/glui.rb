class Glui < Formula
  desc "C++ user interface library"
  homepage "http://glui.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/glui/Source/2.36/glui-2.36.tgz"
  sha256 "c1ef5e83cf338e225ce849f948170cd681c99661a5c2158b4074515926702787"

  bottle do
    cellar :any_skip_relocation
    sha256 "36971571cceb35b758732131c7c9495d01b95fb2d4130000039c1b9d9a3922d8" => :sierra
    sha256 "eae0f5aab2883fa397f09bb314a90672e41c39c24e0c43e49259c8016b1c50db" => :el_capitan
    sha256 "617c71a79c2ce69ff31e7bd84e9e4f41b09e8cf3d039190bef92ad6bf1ae416c" => :yosemite
    sha256 "1a5b5bc92fbb7077f11f53fcbd16d1e63b1e04850d029afa2a8e82822a5e82e4" => :mavericks
  end

  # Fix compiler warnings in glui.h. Reported upstream:
  # https://sourceforge.net/p/glui/patches/12/
  patch :DATA

  def install
    cd "src" do
      system "make", "setup"
      system "make", "lib/libglui.a"
      lib.install "lib/libglui.a"
      include.install "include/GL"
    end
  end
end

__END__
diff --git a/src/include/GL/glui.h b/src/include/GL/glui.h
index 01a5c75..5784e29 100644
--- a/src/include/GL/glui.h
+++ b/src/include/GL/glui.h
@@ -941,7 +941,7 @@ public:
         spacebar_mouse_click = true;    /* Does spacebar simulate a mouse click? */
         live_type      = GLUI_LIVE_NONE;
         text = "";
-        last_live_text == "";
+        last_live_text = "";
         live_inited    = false;
         collapsible    = false;
         is_open        = true;
