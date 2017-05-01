class Osh < Formula
  desc "Two ports of /bin/sh from V6 UNIX (circa 1975)"
  homepage "https://v6shell.org/"
  url "https://v6shell.org/src/osh-4.3.2.tar.gz"
  sha256 "6123b24cd87e70cbf99f26ce5dea992abedf7e4f0c6ad964853427919b47dcc7"
  version_scheme 1
  head "https://github.com/JNeitzel/v6shell.git"

  bottle do
    sha256 "c6980a4d8bdcafab037ac119aa2a476136ac6b470ea07543b704f6ecfa792db5" => :sierra
    sha256 "aacbe0d58afc432c0e717223da2835e8c2c9baac8aec426826612d37b777f80c" => :el_capitan
    sha256 "a2d8427887d4776b0168e1503da1c7b03b7393229c6ec3e70e9c0d4ff4ff3f21" => :yosemite
  end

  option "with-examples", "Build with shell examples"

  resource "examples" do
    url "https://v6shell.org/v6scripts/v6scripts-20160128.tar.gz"
    sha256 "c23251137de67b042067b68f71cd85c3993c566831952af305f1fde93edcaf4d"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "SYSCONFDIR=#{etc}", "MANDIR=#{man}"

    if build.with? "examples"
      resource("examples").stage do
        ENV.prepend_path "PATH", bin
        system "./INSTALL", libexec
      end
    end
  end

  test do
    assert_match "brew!", shell_output("#{bin}/osh -c 'echo brew!'").strip

    if build.with? "examples"
      ENV.prepend_path "PATH", libexec
      assert_match "1 3 5 7 9 11 13 15 17 19", shell_output("#{libexec}/counts").strip
    end
  end
end
