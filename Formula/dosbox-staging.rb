class DosboxStaging < Formula
  desc "Modernized DOSBox soft-fork"
  homepage "https://dosbox-staging.github.io/"
  url "https://github.com/dosbox-staging/dosbox-staging/archive/v0.76.0.tar.gz"
  sha256 "7df53c22f7ce78c70afb60b26b06742b90193b56c510219979bf12e0bb2dc6c7"
  license "GPL-2.0-or-later"
  head "https://github.com/dosbox-staging/dosbox-staging.git"

  bottle do
    cellar :any
    sha256 "4c2ee8d684cf3d2601d9cc384eaa8be5ad7576453b294626b0fb479c983622ce" => :big_sur
    sha256 "23aa0a9c485a142359745f3e051f308ef36b0ac87f3ed52952f5789ff9d96b3b" => :catalina
    sha256 "b917df2aa548aecb7cab523c04d34ce6e7db352446c81fd4e116253adf525b8e" => :mojave
    sha256 "eee8889b23dc83f70bebf1836a0fa4f47f2c60419bd5d94523674ad5dd5ffd00" => :high_sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libpng"
  depends_on "opusfile"
  depends_on "sdl2"
  depends_on "sdl2_net"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-fluidsynth
      --disable-sdltest
      --enable-core-inline
    ]

    system "./autogen.sh"
    system "./configure", *args
    system "make", "install"
    mv bin/"dosbox", bin/"dosbox-staging"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dosbox-staging -version")
    mkdir testpath/"Library/Preferences/DOSBox"
    touch testpath/"Library/Preferences/DOSBox/dosbox-staging.conf"
    output = shell_output("#{bin}/dosbox-staging -printconf")
    assert_equal "#{testpath}/Library/Preferences/DOSBox/dosbox-staging.conf", output.chomp
  end
end
