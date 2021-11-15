class Mp3blaster < Formula
  desc "Text-based mp3 player"
  homepage "https://mp3blaster.sourceforge.io"
  url "https://downloads.sourceforge.net/project/mp3blaster/mp3blaster/mp3blaster-3.2.6/mp3blaster-3.2.6.tar.gz"
  sha256 "43d9f656367d16aaac163f93dc323e9843c3dd565401567edef3e1e72b9e1ee0"
  license "GPL-2.0"

  bottle do
    sha256 arm64_monterey: "fd1f48b5c9a6b564fbc5cd37cf597c7955f50b142ee33e0f074451210b9e40c4"
    sha256 arm64_big_sur:  "638fe9765eebafa021a8fb328ef8dd742e047eceb540706792cf828abd4382ab"
    sha256 monterey:       "1dc458652f87f22131f87e7ca45f5765c24d4ab616904f286b8e353859627e70"
    sha256 big_sur:        "7a507393848bbaa8d06f64be1b528256589a3627577f1298dea50353f3303cef"
    sha256 catalina:       "5345ef5c262adc849318b2ee1cb092d794be9b9b952ebf23b0dbf666f8a5f460"
    sha256 mojave:         "8d7c349befa2a093cee2b1fea30ece26393069c19508defb4582a5f7e8200dda"
    sha256 high_sierra:    "da013614ce379f9037f2e6fc684adfe51918e40659577650a229dbd1c6f53847"
    sha256 sierra:         "6dd3817fae76ae7d928688836c580a46e0a6c2f3111507ea6c7a5ae17a1728a7"
    sha256 el_capitan:     "a9e7e56d97d45cd2e06819f15dedc2db738b70836a5897fb23a682202e2fb5b5"
    sha256 yosemite:       "87ba8218ac7bceab2d0f388aae88e6c6a0f6dba2aad11b434d2370ab8ce8251a"
  end

  depends_on "sdl"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/mp3blaster", "--version"
  end
end
