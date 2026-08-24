class Libtool < Formula
  desc "Generic library support script"
  homepage "https://www.gnu.org/software/libtool/"
  url "https://ftpmirror.gnu.org/gnu/libtool/libtool-2.6.2.tar.xz"
  mirror "https://ftp.gnu.org/gnu/libtool/libtool-2.6.2.tar.xz"
  sha256 "2ef1067c16c97db930fd740cc9bc3d3ba9a583804ae5ac42cc3e8719e49e191e"
  license "GPL-2.0-or-later"
  compatibility_version 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "719ae9c4597d0198ee77da6bb09dfcb6f68ae0302330f1a1e61503648e59fdd2"
    sha256 cellar: :any, arm64_sequoia: "86f6495e08630095d0a0a4a8be76d8ba0350985a55ec13fb43a73f5473d2a410"
    sha256 cellar: :any, arm64_sonoma:  "6d51bf4ccdbc2a0cb7c23d71edc885130c955193ce6f388ab77411f8ebd4305a"
    sha256 cellar: :any, tahoe:         "c94ba9b047fa5744349911cd632fec5b88cd366991bb39cb06fe018d166a0a39"
    sha256 cellar: :any, sequoia:       "205e69efbbd83ca9ff421c98a0063bd20b64690b44248d0398bd6deb941cf81b"
    sha256 cellar: :any, sonoma:        "616479dd74d4824d290395c2551ce07c69a715b92bb3901c1438ad734e2e45d0"
    sha256 cellar: :any, arm64_linux:   "2cd12463505a1ca40c2e3f54c2777f57acb6134b92d6cfd8631180f771d2d87a"
    sha256 cellar: :any, x86_64_linux:  "6987dea502aa790323eeed36812983d07620595eff67992f1d6992f4de98e136"
  end

  depends_on "m4"

  def install
    ENV["M4"] = formula_opt_bin("m4")/"m4"

    args = %w[
      --disable-silent-rules
      --enable-ltdl-install
    ]
    args << "--program-prefix=g" if OS.mac?

    system "./configure", *args, *std_configure_args
    system "make", "install"

    if OS.mac?
      %w[libtool libtoolize].each do |prog|
        (libexec/"gnubin").install_symlink bin/"g#{prog}" => prog
        (libexec/"gnuman/man1").install_symlink man1/"g#{prog}.1" => "#{prog}.1"
      end
      (libexec/"gnubin").install_symlink "../gnuman" => "man"
    else
      bin.install_symlink "libtool" => "glibtool"
      bin.install_symlink "libtoolize" => "glibtoolize"

      # Avoid references to the Homebrew shims directory
      inreplace bin/"libtool", Superenv.shims_path, "/usr/bin"
    end
  end

  def caveats
    on_macos do
      <<~EOS
        All commands have been installed with the prefix "g".
        If you need to use these commands with their normal names, you
        can add a "gnubin" directory to your PATH from your bashrc like:
          PATH="#{opt_libexec}/gnubin:$PATH"
      EOS
    end
  end

  test do
    system bin/"glibtool", "execute", File.executable?("/usr/bin/true") ? "/usr/bin/true" : "/bin/true"

    (testpath/"hello.c").write <<~C
      #include <stdio.h>
      int main() { puts("Hello, world!"); return 0; }
    C

    system bin/"glibtool", "--mode=compile", "--tag=CC",
      ENV.cc, "-c", "hello.c", "-o", "hello.o"
    system bin/"glibtool", "--mode=link", "--tag=CC",
      ENV.cc, "hello.o", "-o", "hello"
    assert_match "Hello, world!", shell_output("./hello")

    system bin/"glibtoolize", "--ltdl"
  end
end
