class OmegaRpg < Formula
  desc "The classic Roguelike game"
  homepage "http://www.alcyone.com/max/projects/omega/"
  url "http://www.alcyone.com/binaries/omega/omega-0.80.2-src.tar.gz"
  sha256 "60164319de90b8b5cae14f2133a080d5273e5de3d11c39df080a22bbb2886104"
  revision 1

  bottle do
    sha256 "10390c232402e60f1397665338d15d0448dc992c950a09a72fbf94c812af9aa8" => :mojave
    sha256 "f4a5911b81f9919e68c5bd35f8e3d13240045b09e57b622f4766e747bb3e6a03" => :high_sierra
    sha256 "06008f528a9ac14c6b7e1f9be84a5e76a4ad4df234344e7e13eaedb108ce4b04" => :sierra
    sha256 "d46db018d9c54c5a0460f46763a218b6bff1bf277aca19fe91b17965dac3a367" => :el_capitan
    sha256 "1b5b760d814cf07c4d9daa8dbcbcccfc38038dbab140ed182ad514bad07fe932" => :yosemite
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
