class Nazghul < Formula
  desc "Computer role-playing game engine"
  homepage "https://web.archive.org/web/20130402222926/myweb.cableone.net/gmcnutt/nazghul.html"
  url "https://downloads.sourceforge.net/project/nazghul/nazghul/nazghul-0.7.1/nazghul-0.7.1.tar.gz"
  sha256 "f1b62810da52a116dfc1c407dbe683991b1b380ca611f57b5701cfbb803e9d2b"

  bottle do
    cellar :any
    sha256 "7756c6eb0de2459aeb77a71641db006e87dd53d101e7d763e7d1b9f5d8789675" => :sierra
    sha256 "3b6326f1007694c4d557f9e7dd3ea5d46ce3dc3133eb9deb46bb183938a40cbe" => :el_capitan
    sha256 "a76cc9e7389be6b0438ab9d5f2cf4ae9035989653785eace7617caac66b5b34e" => :yosemite
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
