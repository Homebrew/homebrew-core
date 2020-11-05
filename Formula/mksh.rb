class Mksh < Formula
  desc "MirBSD Korn Shell"
  homepage "https://www.mirbsd.org/mksh.htm"
  url "https://www.mirbsd.org/MirOS/dist/mir/mksh/mksh-R59c.tgz"
  mirror "https://pub.allbsd.org/MirOS/dist/mir/mksh/mksh-R59c.tgz"
  version "59c"
  sha256 "77ae1665a337f1c48c61d6b961db3e52119b38e58884d1c89684af31f87bc506"

  livecheck do
    url "https://www.mirbsd.org/MirOS/dist/mir/mksh/"
    regex(/href=.*?mksh-R?(\d+[a-z]?)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "e6b59cb6a1bb326e97bbbad191d735e85e39f899726a68225c01e137ea88066f" => :catalina
    sha256 "1360021d58dfbb2b4baedc74ad72890ee1aa4178865c4aa61e6142da58ba8c06" => :mojave
    sha256 "249f6b7a2ea7d278fd5b21ec947d9f88eeb8d803f28c286e140aa293beaf301d" => :high_sierra
  end

  def install
    system "sh", "./Build.sh", "-r"
    bin.install "mksh"
    man1.install "mksh.1"
  end

  test do
    assert_equal "honk",
      shell_output("#{bin}/mksh -c 'echo honk'").chomp
  end
end
