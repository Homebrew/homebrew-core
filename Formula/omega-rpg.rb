class OmegaRpg < Formula
  desc "The classic Roguelike game"
  homepage "http://www.alcyone.com/max/projects/omega/"
  url "http://www.alcyone.com/binaries/omega/omega-0.80.2-src.tar.gz"
  sha256 "60164319de90b8b5cae14f2133a080d5273e5de3d11c39df080a22bbb2886104"
  revision 1

  bottle do
    sha256 "66fb30477b59d100f7ac35e186202dedd60682bc4650784f82be599e839b2c6a" => :yosemite
    sha256 "95f29ae642a99f7c830aa6af6ff645a23ea19ebd02e781eb354e0db646088f9d" => :mavericks
    sha256 "64968e94d82f9664cb571b59bdddc10c119dd278e99e7c026a63c0421e93951e" => :mountain_lion
  end

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
    ln_s prefix/"license.txt", libexec/"license.txt"
  end
end
