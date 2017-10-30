class Mksh < Formula
  desc "MirBSD Korn Shell"
  homepage "https://www.mirbsd.org/mksh.htm"
  url "https://www.mirbsd.org/MirOS/dist/mir/mksh/mksh-R56b.tgz"
  mirror "https://dl.bintray.com/homebrew/mirror/mksh-56b.tgz"
  version "56b"
  sha256 "40ec744eec256583e4e18907cde22af57c980286f535df47326fed07e48c9a7f"

  bottle do
    cellar :any_skip_relocation
    sha256 "6098461be38111921ac20b4079fbf526e902335551db5390a36444cb35c1433c" => :high_sierra
    sha256 "92b1f35f5311b97ed642b740a3f27b06b87b602004d75c401d342ad4f1622b8f" => :sierra
    sha256 "869c03bacc72c9d7d56f9a1371bef7072df1d39213cf6cc23b924cb7056d7853" => :el_capitan
    sha256 "f60810eeec945b44fccf6b64943666d0c4aab9fe0d0cd94c37cda411073ccc29" => :yosemite
  end

  def install
    system "sh", "./Build.sh", "-r", "-c", (ENV.compiler == :clang) ? "lto" : "combine"
    bin.install "mksh"
    man1.install "mksh.1"
  end

  def caveats; <<~EOS
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
