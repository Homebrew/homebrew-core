class Mksh < Formula
  desc "MirBSD Korn Shell"
  homepage "https://www.mirbsd.org/mksh.htm"
  url "https://www.mirbsd.org/MirOS/dist/mir/mksh/mksh-R55.tgz"
  mirror "https://pub.allbsd.org/MirOS/dist/mir/mksh/mksh-R55.tgz"
  sha256 "ced42cb4a181d97d52d98009eed753bd553f7c34e6991d404f9a8dcb45c35a57"

  bottle do
    cellar :any_skip_relocation
    sha256 "9e0b4936345b39cbbb0cfda7702528eb92fb723b60decd1be2522863dd596e69" => :sierra
    sha256 "d3437810086c5ac4b89cd09dd39add4a8c2873344fd6b48e6961acf69366f22b" => :el_capitan
    sha256 "b5f7b0a0d6110edd9aae8d2be717983cc6f0fafcbdfc5cc62cb051fbb636ed3c" => :yosemite
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
