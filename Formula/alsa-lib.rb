class AlsaLib < Formula
  desc "Provides audio and MIDI functionality to the Linux operating system"
  homepage "https://www.alsa-project.org/"
  url "https://www.alsa-project.org/files/pub/lib/alsa-lib-1.2.7.2.tar.bz2"
  sha256 "8a35b7218e50f2a2c79342d0de98ded81439ce19e12809385ec9be9596de7c2f"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://www.alsa-project.org/files/pub/lib/"
    regex(/href=.*?alsa-lib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 x86_64_linux: "9e9409e572680975dd401de6d0466ebc5b8bf2832cd013f2c88fc2022d48addb"
  end

  depends_on :linux

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <alsa/asoundlib.h>
      int main(void)
      {
          snd_ctl_card_info_t *info;
          snd_ctl_card_info_alloca(&info);
          return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lasound", "-o", "test"
    system "./test"
  end
end
