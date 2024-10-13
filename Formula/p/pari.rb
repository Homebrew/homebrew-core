class Pari < Formula
  desc "Computer algebra system designed for fast computations in number theory"
  homepage "https://pari.math.u-bordeaux.fr/"
  url "https://pari.math.u-bordeaux.fr/pub/pari/unix/pari-2.17.0.tar.gz"
  sha256 "e723e7cef18d08c6ece2283af9a9b4d56077c22b4fce998faaa588d389b1aea8"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://pari.math.u-bordeaux.fr/pub/pari/unix/"
    regex(/href=.*?pari[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "a872743b47cdc2fb07705883dd40165dca85b678d0175f90906a5e014b195ca2"
    sha256 cellar: :any,                 arm64_sonoma:  "302862e50bd4b8364d3c37bcf605dec272524b3d8a8c3c58bf3ebb90fd2ac884"
    sha256 cellar: :any,                 arm64_ventura: "4a5dfa16dbc234c37111d09dd4afa1d1ed83b7e263042192480066c4895c5194"
    sha256 cellar: :any,                 sonoma:        "135c26329c52480015f9691ad86e23ee95c1998ca6bb2341d339f61c81e738c8"
    sha256 cellar: :any,                 ventura:       "edc23f635ae0befedff9317806d862e35739f852627a5992905f4897caf76e94"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "66c539100e883305cc73cb26f21640ddd85ed78451f8bf678f1ef9f98b8a6396"
  end

  depends_on "gmp"
  depends_on "readline"

  def install
    readline = Formula["readline"].opt_prefix
    gmp = Formula["gmp"].opt_prefix
    system "./Configure", "--prefix=#{prefix}",
                          "--with-gmp=#{gmp}",
                          "--with-readline=#{readline}",
                          "--graphic=ps",
                          "--mt=pthread"

    # Explicitly set datadir to HOMEBREW_PREFIX/share/pari to allow for external packages to be found
    # We do this here rather than in configure because we still want the actual files to be installed to the Cellar
    objdir = Utils.safe_popen_read("./config/objdir").chomp
    inreplace %W[#{objdir}/pari.cfg #{objdir}/paricfg.h], pkgshare, "#{HOMEBREW_PREFIX}/share/pari"

    # make needs to be done in two steps
    system "make", "all"
    system "make", "install"

    # Avoid references to Homebrew shims
    inreplace lib/"pari/pari.cfg", Superenv.shims_path, "/usr/bin"
  end

  def caveats
    <<~EOS
      If you need the graphical plotting functions you need to install X11 with:
        brew install --cask xquartz
    EOS
  end

  test do
    (testpath/"math.tex").write "$k_{n+1} = n^2 + k_n^2 - k_{n-1}$"
    system bin/"tex2mail", testpath/"math.tex"
  end
end
