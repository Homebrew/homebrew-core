class Libtecla < Formula
  desc "Command-line editing facilities similar to the tcsh shell"
  homepage "https://sites.astro.caltech.edu/~mcs/tecla/"
  url "https://sites.astro.caltech.edu/~mcs/tecla/libtecla-1.6.3.tar.gz"
  sha256 "f2757cc55040859fcf8f59a0b7b26e0184a22bece44ed9568a4534a478c1ee1a"

  livecheck do
    url :homepage
    regex(/href=.*?libtecla[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b2bad924df3143f0253bf5bee8dcb8522b905812bafd7134e64fabc2b278e94d"
    sha256 cellar: :any,                 arm64_monterey: "8153bfc3fe19fea63cc58b318cd4878c426f0e4256b5a381171e9b11b36d4bf4"
    sha256 cellar: :any,                 arm64_big_sur:  "663c10759f3e00d87a360640de2d0eedb16c8e2e8b26a375f4f3fceaf356a445"
    sha256 cellar: :any,                 ventura:        "156d7de2fd3f8d531266f8df1178e26e5779cd93eb36a38062e9611d1fc8fbbf"
    sha256 cellar: :any,                 monterey:       "7e9cdf4692258796b655934aa501b94a46b88291334b1bed79a44dd4ea205b20"
    sha256 cellar: :any,                 big_sur:        "d0f28c06cf9d2d1669298104439c4e194d21df65fc17e9b95e9dec0383aa7fef"
    sha256 cellar: :any,                 catalina:       "a6bbfa1cee4b62a03186d6fa1a153fceb2b3b9ae5cdf63411d6432c6251c753b"
    sha256 cellar: :any,                 mojave:         "d39e8711f7a9a5a11433c7c92a2113a97f8846796f93fa7bca1281e06db2e3fe"
    sha256 cellar: :any,                 high_sierra:    "dffae78362e21bf324ed651a2b80ff924b1bbec60916159863e66c7171072a9c"
    sha256 cellar: :any,                 sierra:         "21cd696f6e79ae6401dd19f832ac24263f016a62c2d15ec31e25d515bbea5983"
    sha256 cellar: :any,                 el_capitan:     "3ceb3942ea4ae1434dcc0aea00fa58b6f16787bc1a0067e9497ad4cb050f771a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bcf6021a1cff18af685065c3778f709fdcc17e22767818c6e5fef4e309adc3e"
  end

  # Added automake as a build dependency to update config files for ARM support.
  # Please remove in the future if there is a patch upstream which recognises aarch64 macOS.
  depends_on "automake" => :build

  uses_from_macos "ncurses"

  def install
    ENV.deparallelize

    %w[config.guess config.sub].each do |fn|
      cp "#{Formula["automake"].opt_prefix}/share/automake-#{Formula["automake"].version.major_minor}/#{fn}", fn
    end

    # Fix hard coded flat namespace usage in configure.
    inreplace "configure", "-flat_namespace -undefined suppress", "-undefined dynamic_lookup"
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <locale.h>
      #include <libtecla.h>

      int main(int argc, char *argv[]) {
        GetLine *gl;
        setlocale(LC_CTYPE, "");
        gl = new_GetLine(1024, 2048);
        if (!gl) return 1;
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-ltecla", "-lcurses", "-o", "test"
    system "./test"
  end
end
