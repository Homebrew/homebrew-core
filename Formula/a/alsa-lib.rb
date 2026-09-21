class AlsaLib < Formula
  desc "Provides audio and MIDI functionality to the Linux operating system"
  homepage "https://www.alsa-project.org/"
  url "https://www.alsa-project.org/files/pub/lib/alsa-lib-1.2.16.1.tar.bz2"
  sha256 "f740db7f488255944ffd4428416ee3390a96742856916433df468c281436480e"
  license all_of: ["LGPL-2.1-or-later", "GPL-2.0-or-later"]
  revision 1
  compatibility_version 1

  livecheck do
    url "https://www.alsa-project.org/files/pub/lib/"
    regex(/href=.*?alsa-lib[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_linux:  "b1ae855e221183539e46de1223bd314cada603de3e8d4b34737774cbe272d0d1"
    sha256 x86_64_linux: "2585ca003b5d398419bffad120e55d7b0429c0986e70bf03e7435329136013ac"
  end

  depends_on :linux

  def install
    args = %W[
      --disable-silent-rules
      --with-plugindir=#{HOMEBREW_PREFIX}/lib/alsa-lib
    ]
    system "./configure", *args, *std_configure_args
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
