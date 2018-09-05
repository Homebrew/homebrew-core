class Mksh < Formula
  desc "MirBSD Korn Shell"
  homepage "https://www.mirbsd.org/mksh.htm"
  url "https://www.mirbsd.org/MirOS/dist/mir/mksh/mksh-R56c.tgz"
  mirror "https://dl.bintray.com/homebrew/mirror/mksh-56c.tgz"
  version "56c"
  sha256 "dd86ebc421215a7b44095dc13b056921ba81e61b9f6f4cdab08ca135d02afb77"

  bottle do
    cellar :any_skip_relocation
    sha256 "af3e53f3876dad1d565c1d8dc88cbd84901ea0bf50599dc66369ee5d6f853a60" => :mojave
    sha256 "4ec398134339f30d26fe53dc2b8d8cf415b196c7cb84327c43cdf506a77376df" => :high_sierra
    sha256 "79d49b6a5b52e1656443ef32c3a55566cc2ff7c1668e80f85011e9bee92d8567" => :sierra
    sha256 "7343ace15a9f87d07cf35a4074c093104c68666c8443d9bb120e58dd660ccf70" => :el_capitan
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
