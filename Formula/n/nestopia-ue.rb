class NestopiaUe < Formula
  desc "NES emulator"
  homepage "http://0ldsk00l.ca/nestopia/"
  url "https://github.com/0ldsk00l/nestopia/archive/refs/tags/1.53.1.tar.gz"
  sha256 "21aa45f6c608fe290d73fdec0e6f362538a975455b16a4cc54bcdd10962fff3e"
  license "GPL-2.0-or-later"
  head "https://github.com/0ldsk00l/nestopia.git", branch: "master"

  bottle do
    sha256 arm64_sequoia: "9a00ff8b6b1eff8d5774ed427afbdb669cb512905268409ca102f15d32e7757b"
    sha256 arm64_sonoma:  "536e84f8e7dddec0baa5f84701f03022bc71019b4249475ea69d452f998c8468"
    sha256 arm64_ventura: "4e9a0b4a72e6e41b6ce1064504e0784f56282f8e923baf7be176c98a3cc262d5"
    sha256 sonoma:        "ae9bddfba1d0fcb99e3b6fcb0a1c8f5671db3c76431ce9e3654fb7387da0a8ee"
    sha256 ventura:       "107be843559d0aa3bb8b331cd75a3e1361eac8c2ce73463c73e944d0ff9fd66f"
    sha256 arm64_linux:   "7d2a96b45a372cb24b73391d12423a3056dfc2167f4926528b292b4de763efa1"
    sha256 x86_64_linux:  "a04a201661a975527c42693e5b84b11f2f3eff999a78c7ee966483165959d7ed"
  end

  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "pkgconf" => :build

  depends_on "fltk"
  depends_on "libarchive"
  depends_on "libepoxy"
  depends_on "libsamplerate"
  depends_on "sdl2"

  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa"
  end

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules",
                          "--datarootdir=#{pkgshare}",
                          *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "Nestopia UE #{version}", shell_output("#{bin}/nestopia --version")
  end
end
