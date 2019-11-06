class OmegaRpg < Formula
  desc "The classic Roguelike game"
  homepage "http://www.alcyone.com/max/projects/omega/"
  url "http://www.alcyone.com/binaries/omega/omega-0.80.2-src.tar.gz"
  sha256 "60164319de90b8b5cae14f2133a080d5273e5de3d11c39df080a22bbb2886104"
  revision 1

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4ab6747f5c291b26c9ba5b750d98ee6368f42dc35039bf23b2e401a318fb87f6" => :catalina
    sha256 "8161e569d07cae64b550fa2f2e795171ca82b65b283cf1e45056b61d12fa71f5" => :mojave
    sha256 "0b08d090868aa2b1da56645e74ea87d6a15043c473aba35e56f3fbf2e4b4f4d4" => :high_sierra
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
