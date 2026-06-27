class Bc < Formula
  desc "Arbitrary precision numeric processing language"
  homepage "https://www.gnu.org/software/bc/"
  url "https://ftpmirror.gnu.org/gnu/bc/bc-1.08.2.tar.gz"
  mirror "https://ftp.gnu.org/gnu/bc/bc-1.08.2.tar.gz"
  sha256 "ae470fec429775653e042015edc928d07c8c3b2fc59765172a330d3d87785f86"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0651089dd302a018f373870702769aee045e37420816f31f54d63d61ed92eaa0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1817f18a3e007d00b9128d225cc1aa8c18ea8673d954bea60e5a4d95fc8b4ff9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08dc983bea3e325521a62c8f3eae7e9e414512c740cb99f7f0ea44e11fb1d213"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "205744876113e5f7ecd60bba584731c339386d3defc852d74a82cd01a64dea97"
    sha256 cellar: :any_skip_relocation, sonoma:        "eee028e2110a7e11ed6e7031617377654d2e3260a8b753d9965d165488b39afb"
    sha256 cellar: :any_skip_relocation, ventura:       "e2417d6a027f54331bbf1d5290dfaed83c3811c7e88ebb163e8bbbcf46e98f11"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "aaa02a5b2ea9e4fa53a6266398cf51f3deabc3d0ce6a655b9abedcacc300d786"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e08ff27c11d109f803062119b73e680335a27a2229b7c1283c123559aa073f49"
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
