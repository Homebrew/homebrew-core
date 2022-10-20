class OmegaRpg < Formula
  desc "Classic Roguelike game"
  homepage "http://www.alcyone.com/max/projects/omega/"
  url "http://www.alcyone.com/binaries/omega/omega-0.80.2-src.tar.gz"
  sha256 "60164319de90b8b5cae14f2133a080d5273e5de3d11c39df080a22bbb2886104"
  revision 1

  livecheck do
    url :homepage
    regex(/latest.*?>v?(\d+(?:\.\d+)+)</i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ab67527e0eeb05713b51165bad1cfe9fbf8d0bcc1009a4b1b5f73bddc626d169"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38000e1217562bc9cf2db49e0eb16aa4e7b5648010539fc5c9bb0608f3e1fc20"
    sha256                               monterey:       "76844b55561305089dc6270dad5a00f45fa17428f7702ff100860c70e604379a"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc9ea79ad3baebccf29fa3e16fe023a05564ca2f4c8c9f67bf45c3f0d471993e"
    sha256 cellar: :any_skip_relocation, catalina:       "4ab6747f5c291b26c9ba5b750d98ee6368f42dc35039bf23b2e401a318fb87f6"
    sha256 cellar: :any_skip_relocation, mojave:         "8161e569d07cae64b550fa2f2e795171ca82b65b283cf1e45056b61d12fa71f5"
    sha256 cellar: :any_skip_relocation, high_sierra:    "0b08d090868aa2b1da56645e74ea87d6a15043c473aba35e56f3fbf2e4b4f4d4"
    sha256                               x86_64_linux:   "b7da84e88747a0e8f6715fa1961aed8004845da0eaeb523a9ee35271db6f9305"
  end

  uses_from_macos "ncurses"

  def install
    # Set up our target folders
    inreplace "defs.h", "#define OMEGALIB \"./omegalib/\"", "#define OMEGALIB \"#{libexec}/\""

    # Don't alias CC; also, don't need that ncurses include path
    # Set the system type in CFLAGS, not in makefile
    # Remove an obsolete flag
    inreplace "Makefile" do |s|
      s.remove_make_var! ["CC", "CFLAGS", "LDFLAGS"]
    end

    ENV.append_to_cflags "-DUNIX -DSYSV"

    system "make"

    # 'make install' is weird, so we do it ourselves
    bin.install "omega"
    libexec.install Dir["omegalib/*"]
  end

  def post_install
    # omega refuses to run without license.txt in OMEGALIB
    license_file = libexec/"license.txt"
    prefix.install_symlink license_file unless license_file.exist?
  end
end
