class Mksh < Formula
  desc "MirBSD Korn Shell"
  homepage "https://www.mirbsd.org/mksh.htm"
  url "https://www.mirbsd.org/MirOS/dist/mir/mksh/mksh-R55.tgz"
  mirror "https://pub.allbsd.org/MirOS/dist/mir/mksh/mksh-R55.tgz"
  sha256 "ced42cb4a181d97d52d98009eed753bd553f7c34e6991d404f9a8dcb45c35a57"

  bottle do
    cellar :any_skip_relocation
    sha256 "4105d7c15156683e919a9b26be1a6c73c0ee6f4dcbc23236690977a370d36a09" => :sierra
    sha256 "85be92bfc3197078676eb1c1938d12f040ffe7b02b84c307db9d5ba5644e1960" => :el_capitan
    sha256 "bd9619a5f6e39befae565d833840e83b49da62865764d80791c43efbcfe9e32d" => :yosemite
  end

  def install
    system "sh", "./Build.sh", "-r", "-c", (ENV.compiler == :clang ? "lto" : "combine")
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
