class Nazghul < Formula
  desc "Computer role-playing game engine"
  homepage "https://web.archive.org/web/20130402222926/http://myweb.cableone.net/gmcnutt/nazghul.html"
  url "https://downloads.sourceforge.net/project/nazghul/nazghul/nazghul-0.7.1/nazghul-0.7.1.tar.gz"
  sha256 "f1b62810da52a116dfc1c407dbe683991b1b380ca611f57b5701cfbb803e9d2b"

  bottle do
    cellar :any
    sha256 "463268eb22b46f6197ccfc8c7042306cc63d9da14fb64e39af391fa8e63b4bcd" => :yosemite
    sha256 "be226e182e99ef8944baf85c34c46f3820e24ccb3052d1f267d2edc6d313f02c" => :mavericks
    sha256 "8212dbd986171a00d9f2a986ef52394daf2cfc98ed20b8697332880cd20f6343" => :mountain_lion
  end

  depends_on "sdl"
  depends_on "sdl_image"
  depends_on "sdl_mixer"
  depends_on "libpng"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-sdltest",
                          "--bindir=#{libexec}"
    # Not sure why the ifdef is commented out in this file
    inreplace "src/skill.c", "#include <malloc.h>", ""
    system "make", "install"

    # installing into libexec then rewriting the wrapper script so the
    # program name is 'haxima' rather than 'haxima.sh' and there isn't
    # a 'nazghul' executable in bin to confuse the user
    (bin/"haxima").write <<-EOS.undent
      #!/bin/sh
      "/usr/local/Cellar/nazghul/0.7.1/libexec/nazghul" -I "/usr/local/Cellar/nazghul/0.7.1/share/nazghul/haxima" -G "$HOME/.haxima" "$@"
    EOS
  end

  test do
    assert_match version.to_s,
                 shell_output("#{bin}/haxima -v")
  end
end
