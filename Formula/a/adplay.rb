class Adplay < Formula
  desc "Command-line player for OPL2 music"
  homepage "https://adplug.github.io"
  license "GPL-2.0-or-later"
  head "https://github.com/adplug/adplay-unix.git", branch: "master"

  stable do
    url "https://github.com/adplug/adplay-unix/releases/download/v1.8.1/adplay-1.8.1.tar.bz2"
    sha256 "eb36bd6a7066980ce5b72aa710a784dfb37a0ffe6dfc506a5eeef6c7485edfd5"

    # Fixes a header conflict between adplay and SDL
    # on case-insensitive filesystems
    # Will be in the next release
    # https://github.com/adplug/adplay-unix/pull/28
    patch do
      url "https://github.com/adplug/adplay-unix/commit/e062cd2925f7cdb08a2a2ac612b6fcac9d1df2fa.patch?full_index=1"
      sha256 "2724a8c2ccbfec68de7dc9c30911b141a0cf67ed69b66eed63812223296e68dc"
    end

    # Fixes finding getopt headers on macOS
    # Will be in the next release
    # https://github.com/adplug/adplay-unix/pull/29
    patch do
      url "https://github.com/adplug/adplay-unix/commit/95ea7955a4900455491ca7d034abac054c23bf37.patch?full_index=1"
      sha256 "63564a807b30482738a9f3283049fbb2b31aa17809d67b074e8c404169a17f9b"
    end

    # Fixes a clash between min/max macros and std::min/std::max
    # Will be in the next release
    # https://github.com/adplug/adplay-unix/pull/18
    patch do
      url "https://github.com/adplug/adplay-unix/commit/95d47d7dcf65a4f0e7371f193c8d936b4e1adc77.patch?full_index=1"
      sha256 "d3c038b28dbf4f369e21541e64f433aaa21a5ed6264cf53eec1faa132c6568d2"
    end
  end

  # autotools needed because one of the above patches
  # touches the buildsystem
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "adplug"
  depends_on "sdl2"

  def install
    # The patch above fails to apply the rename, but only on macOS
    # Seems to be platform-specific difference between macOS `patch`
    # and Linux `patch`
    mv "src/sdl.h", "src/sdl_driver.h" if build.stable? && OS.mac?

    # autoreconf because of the buildsystem changes from the patch
    system "autoreconf", "-ivf"
    system "./configure", *std_configure_args, "--disable-silent-rules",
                          # SDL output works better than libao
                          "--disable-output-ao"
    system "make", "install"
  end

  test do
    assert_includes(shell_output("#{bin}/adplay --version"), "AdPlay/UNIX")
  end
end
