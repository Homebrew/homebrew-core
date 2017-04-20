class Osh < Formula
  desc "Two ports of /bin/sh from V6 UNIX (circa 1975)"
  homepage "https://v6shell.org/"
  url "https://v6shell.org/src/osh-4.3.0.tar.gz"
  sha256 "1173b8feffb617c0ed249f6cb7aff482eae960d8ccfb89f38ed73dab37dae5ed"
  version_scheme 1
  head "https://github.com/JNeitzel/v6shell.git"

  bottle do
    sha256 "919c09e1a4ebfa6f65c54b6ef01cefcc0f7b46ab624e5a269f2653f1737628ee" => :sierra
    sha256 "44635999ca369d9409570c2edd2be64fdafa81b20a6f8891fb045d56c3713e2c" => :el_capitan
    sha256 "ce0faf19c7ba85b573c1a57d9ade604dde12d628918147410d42d19136b21f70" => :yosemite
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
