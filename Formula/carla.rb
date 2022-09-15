class Carla < Formula
  desc "Audio plugin host supporting LADSPA, LV2, VST2/3, SF2 and more"
  homepage "https://kxstudio.linuxaudio.org/Applications:Carla"
  license "GPL-2.0-or-later"
  revision 1
  head "https://github.com/falkTX/Carla.git", branch: "main"

  stable do
    url "https://github.com/falkTX/Carla/archive/v2.4.3.tar.gz"
    sha256 "0092926e5167f3a5eb592f0055e5491803354ae42947e706db0dc548d9e786d3"

    # Fix build failure on Monterey.
    # This change was merged in https://github.com/falkTX/Carla/commit/1e5c9900ae0341ada21b18a58219cbfb70559653
    # Remove with next release.
    patch :DATA
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "91b9647985a6e614ce14330ee49be79772ea2909ce46ff5da23f193ffa363a62"
    sha256 cellar: :any,                 arm64_big_sur:  "325759e3d62a0b84f73e0fbe8dc6e6b78866f1043e80be95aec406769fe25461"
    sha256 cellar: :any,                 monterey:       "52a7165ecb66b48eea1e61e4334733d053f1a9ff62192dc55a5bb391a2606c38"
    sha256 cellar: :any,                 big_sur:        "523a82556c29048c22ed73bfded1410340e1ed46a9972c0f235b3ce457a8afcf"
    sha256 cellar: :any,                 catalina:       "dcf786ecab3962d2cd2d9496e314968f1f7903c1f76ce6692e14cee46d026cfe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccc4816065c21f468728fe81a2989967caab6f365e3547f75175728746922487"
  end

  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "liblo"
  depends_on "libmagic"
  depends_on "pyqt@5"
  depends_on "python@3.10"

  fails_with gcc: "5"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"

    inreplace bin/"carla", "PYTHON=$(which python3 2>/dev/null)",
                           "PYTHON=#{Formula["python@3.10"].opt_bin}/python3.10"
  end

  test do
    system bin/"carla", "--version"
    system lib/"carla/carla-discovery-native", "internal", ":all"
  end
end

__END__
diff --git a/source/discovery/carla-discovery.cpp b/source/discovery/carla-discovery.cpp
index e5a1fec..5c01d85 100644
--- a/source/discovery/carla-discovery.cpp
+++ b/source/discovery/carla-discovery.cpp
@@ -58,11 +58,9 @@
 #ifdef CARLA_OS_MAC
 # define Component CocoaComponent
 # define MemoryBlock CocoaMemoryBlock
-# define Point CocoaPoint
 # import <Foundation/Foundation.h>
 # undef Component
 # undef MemoryBlock
-# undef Point
 # include "CarlaMacUtils.cpp"
 # include <spawn.h>
 # if defined(USING_JUCE) && defined(__aarch64__)
