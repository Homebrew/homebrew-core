class Libtecla < Formula
  desc "Command-line editing facilities similar to the tcsh shell"
  homepage "https://sites.astro.caltech.edu/~mcs/tecla/"
  url "https://sites.astro.caltech.edu/~mcs/tecla/libtecla-1.6.3.tar.gz"
  sha256 "f2757cc55040859fcf8f59a0b7b26e0184a22bece44ed9568a4534a478c1ee1a"
  license "ICU"

  livecheck do
    url :homepage
    regex(/href=.*?libtecla[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "3883edbec56c880a52d9805b5fa4688136ccdb26fe9fe8b4c8b302b3f3c79de4"
    sha256 cellar: :any,                 arm64_sequoia:  "389b4e8a32591e201b3c174ce301bfaeb27a38dd8398992eff9171678d1b4bfc"
    sha256 cellar: :any,                 arm64_sonoma:   "30529250bd3e6f9e4533145538200757b6c0abc0592d192b3c3bb5f4fe25d8fc"
    sha256 cellar: :any,                 arm64_ventura:  "b2bad924df3143f0253bf5bee8dcb8522b905812bafd7134e64fabc2b278e94d"
    sha256 cellar: :any,                 arm64_monterey: "8153bfc3fe19fea63cc58b318cd4878c426f0e4256b5a381171e9b11b36d4bf4"
    sha256 cellar: :any,                 arm64_big_sur:  "663c10759f3e00d87a360640de2d0eedb16c8e2e8b26a375f4f3fceaf356a445"
    sha256 cellar: :any,                 sonoma:         "4d98e5f24629c7b5620f3e343a44607076988af0c447672acb9953b81d4ec24c"
    sha256 cellar: :any,                 ventura:        "156d7de2fd3f8d531266f8df1178e26e5779cd93eb36a38062e9611d1fc8fbbf"
    sha256 cellar: :any,                 monterey:       "7e9cdf4692258796b655934aa501b94a46b88291334b1bed79a44dd4ea205b20"
    sha256 cellar: :any,                 big_sur:        "d0f28c06cf9d2d1669298104439c4e194d21df65fc17e9b95e9dec0383aa7fef"
    sha256 cellar: :any,                 catalina:       "a6bbfa1cee4b62a03186d6fa1a153fceb2b3b9ae5cdf63411d6432c6251c753b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "3a0a9b8648b8766487a1d4c13c394f2560d4b24af9df0e10109fa89dd87b0415"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8bcf6021a1cff18af685065c3778f709fdcc17e22767818c6e5fef4e309adc3e"
  end

  # Added automake as a build dependency to update config files for ARM support.
  # Please remove in the future if there is a patch upstream which recognises aarch64 macOS.
  depends_on "automake" => :build

  uses_from_macos "ncurses"

  def install
    # Workaround for newer Clang
    ENV.append_to_cflags "-Wno-incompatible-function-pointer-types" if DevelopmentTools.clang_build_version >= 1500

    ENV.deparallelize

    %w[config.guess config.sub].each do |fn|
      cp "#{Formula["automake"].opt_prefix}/share/automake-#{Formula["automake"].version.major_minor}/#{fn}", fn
    end

    # Fix hard coded flat namespace usage in configure.
    inreplace "configure", "-flat_namespace -undefined suppress", "-undefined dynamic_lookup"

    # Fix compile with newer Clang
    ENV.append_to_cflags "-Wno-implicit-function-declaration" if DevelopmentTools.clang_build_version >= 1403

    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <locale.h>
      #include <libtecla.h>

      int main(int argc, char *argv[]) {
        GetLine *gl;
        setlocale(LC_CTYPE, "");
        gl = new_GetLine(1024, 2048);
        if (!gl) return 1;
        return 0;
      }
    C

    system ENV.cc, "test.c", "-L#{lib}", "-ltecla", "-lcurses", "-o", "test"
    system "./test"
  end
end
