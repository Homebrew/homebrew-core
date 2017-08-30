class Mksh < Formula
  desc "MirBSD Korn Shell"
  homepage "https://www.mirbsd.org/mksh.htm"
  url "https://www.mirbsd.org/MirOS/dist/mir/mksh/mksh-R56b.tgz"
  mirror "https://dl.bintray.com/homebrew/mirror/mksh-56b.tgz"
  version "56b"
  sha256 "40ec744eec256583e4e18907cde22af57c980286f535df47326fed07e48c9a7f"

  bottle do
    cellar :any_skip_relocation
    sha256 "73256492f020ccbc6c39e7f17daccaa59641328d40ceacd0c8016209b430928b" => :sierra
    sha256 "098f2edcf35536386771f1b4600cab0534dd1f68440fdf2ff9f05bc8f8c9d2a8" => :el_capitan
    sha256 "d78df149585cecb8d678e0561494e71076264ce000f44b8b5dcda69badefaaa3" => :yosemite
  end

  def install
    system "sh", "./Build.sh", "-r", "-c", (ENV.compiler == :clang) ? "lto" : "combine"
    bin.install "mksh"
    man1.install "mksh.1"
  end

  def caveats; <<-EOS.undent
    To allow using mksh as a login shell, run this as root:
        echo #{HOMEBREW_PREFIX}/bin/mksh >> /etc/shells
    Then, any user may run `chsh` to change their shell.
    EOS
  end

  test do
    assert_equal "honk",
      shell_output("#{bin}/mksh -c 'echo honk'").chomp
  end
end
