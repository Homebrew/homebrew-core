class AlsaLib < Formula
  desc "Provides audio and MIDI functionality to the Linux operating system"
  homepage "https://www.alsa-project.org/"
  url "https://www.alsa-project.org/files/pub/lib/alsa-lib-1.2.13.tar.bz2"
  sha256 "8c4ff37553cbe89618e187e4c779f71a9bb2a8b27b91f87ed40987cc9233d8f6"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]

  livecheck do
    url "https://www.alsa-project.org/files/pub/lib/"
    regex(/href=.*?alsa-lib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 x86_64_linux: "b5401dcbbfabbbc67667e8c34eead4678555c0c145b492b3daa8fb1730f3b956"
  end

  depends_on :linux

  def install
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make", "install"
    prefix.install "aserver/COPYING" => "COPYING-aserver"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <alsa/asoundlib.h>
      int main(void)
      {
          snd_ctl_card_info_t *info;
          snd_ctl_card_info_alloca(&info);
          return 0;
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lasound", "-o", "test"
    system "./test"
  end
end
