class Mongrel2 < Formula
  desc "Application, language, and network architecture agnostic web server"
  homepage "https://mongrel2.org/"
  license "BSD-3-Clause"
  head "https://github.com/mongrel2/mongrel2.git", branch: "develop"

  stable do
    url "https://github.com/mongrel2/mongrel2/releases/download/v1.11.0/mongrel2-v1.11.0.tar.bz2"
    sha256 "917f2ce07c0908cae63ac03f3039815839355d46568581902377ba7e41257bed"

    # ensure unit tests work on 1.11.0. remove after next release
    patch do
      url "https://github.com/mongrel2/mongrel2/commit/7cb8532e2ecc341d77885764b372a363fbc72eff.patch?full_index=1"
      sha256 "fa7be14bf1df8ec3ab8ae164bde8eb703e9e2665645aa627baae2f08c072db9a"
    end
  end

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 monterey:     "659082758f176f43b20faecebb11df5a5f1b92237638e1aa083d84f37af0d468"
    sha256 cellar: :any,                 big_sur:      "8f991bcd7c13374bb5cdea84d551da20b5c15885c54c1d9cee8dfc960776cb1d"
    sha256 cellar: :any,                 catalina:     "b410e2526d00b6ba46854e3924889cd96d23c871f9351fb7f050234bbe332904"
    sha256 cellar: :any,                 mojave:       "c0e9720ac266d01411da10390981f34f63308e42b7a5738bebc5378d9c18f134"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1b3aff8dd29b275f0a1a3a57e014adab779fbacc74a8deee8829a27171dbb32e"
  end

  depends_on "zeromq"

  uses_from_macos "sqlite"

  def install
    # Build in serial. See:
    # https://github.com/Homebrew/homebrew/issues/8719
    ENV.deparallelize

    # Mongrel2 pulls from these ENV vars instead
    ENV["OPTFLAGS"] = "#{ENV.cflags} #{ENV.cppflags}"
    ENV["OPTLIBS"] = "#{ENV.ldflags} -undefined dynamic_lookup" if OS.mac?

    system "make", "all"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    system bin/"m2sh", "help"
  end
end
