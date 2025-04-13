class Bc < Formula
  desc "Arbitrary precision numeric processing language"
  homepage "https://www.gnu.org/software/bc/"
  url "https://ftp.gnu.org/gnu/bc/bc-1.08.1.tar.gz"
  mirror "https://ftpmirror.gnu.org/bc/bc-1.08.1.tar.gz"
  sha256 "b71457ffeb210d7ea61825ff72b3e49dc8f2c1a04102bbe23591d783d1bfe996"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e2c49cd3539bc92c81ae5ce1dffe677845e88a4607060bfb929e17615f94922c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3dad88ebb19c3b2f3ff45b61ce9e0136de0d311a7ccecbb7095cfc247e4cfe51"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "82e07f26adbb9832430fd707a1dcf1ae7901bcef2928e84720b3c55c7a3ffd34"
    sha256 cellar: :any_skip_relocation, sonoma:        "25027ce1482683837e17972623a1baa472d55ec68e665f303dba8bb3d7275668"
    sha256 cellar: :any_skip_relocation, ventura:       "2ca58c90ac248548f14591b4c43e8925cef592b43839f4c46847cdcf1ed2cc13"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "315d2ef3d29f405e68d4090309f21fc00d1480ec3b29ddf48afb4b27f9b4c179"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d605e214ec69bd5b1c7331fdade1048f6f580eccc67ffff9f4f7ee30a4163eb5"
  end

  keg_only :provided_by_macos # before Ventura

  uses_from_macos "bison" => :build
  uses_from_macos "ed" => :build
  uses_from_macos "flex"
  uses_from_macos "libedit"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo" => :build
  end

  conflicts_with "bc-gh", because: "both install `bc` and `dc` binaries"

  def install
    # prevent user BC_ENV_ARGS from interfering with or influencing the
    # bootstrap phase of the build, particularly
    # BC_ENV_ARGS="--mathlib=./my_custom_stuff.b"
    ENV.delete("BC_ENV_ARGS")

    system "./configure", "--disable-silent-rules",
                          "--infodir=#{info}",
                          "--mandir=#{man}",
                          "--with-libedit",
                          *std_configure_args
    system "make", "install"
  end

  test do
    system bin/"bc", "--version"
    assert_match "2", pipe_output(bin/"bc", "1+1\n", 0)
  end
end
