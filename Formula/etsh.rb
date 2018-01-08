class Etsh < Formula
  desc "Two ports of /bin/sh from V6 UNIX (circa 1975)"
  homepage "https://etsh.io/"
  url "https://etsh.io/src/etsh-5.0.1.tar.gz"
  sha256 "0433740b6d86625c25a3ef37431736461ceb18443cb8601eb7c11fe07f71a0d1"
  version_scheme 1
  head "https://github.com/JNeitzel/v6shell.git", :branch => "current"

  bottle do
    sha256 "5e72a437ca40c261c7e5c838be1020212b6e08a65ca6c89ad5de145c9fbef4fa" => :high_sierra
    sha256 "ac12cf35b1661ca64b8377d80a0532f9b60c24d0b32656ed19d879b9f4eb9e2c" => :sierra
    sha256 "fe50c9545a3b89097bff241a437575f4365181f2436737aa4313aaa2e42f8412" => :el_capitan
  end

  option "with-examples", "Build with shell examples"

  conflicts_with "teleport", :because => "both install `tsh` binaries"

  resource "examples" do
    url "https://etsh.io/v6scripts/v6scripts-20160128.tar.gz"
    sha256 "c23251137de67b042067b68f71cd85c3993c566831952af305f1fde93edcaf4d"
  end

  def install
    system "./configure"
    system "make", "install", "PREFIX=#{prefix}", "SYSCONFDIR=#{etc}", "MANDIR=#{man1}"
    bin.install_symlink "etsh" => "osh"
    bin.install_symlink "tsh" => "sh6"

    if build.with? "examples"
      resource("examples").stage do
        ENV.prepend_path "PATH", bin
        system "./INSTALL", libexec
      end
    end
  end

  test do
    assert_match "brew!", shell_output("#{bin}/etsh -c 'echo brew!'").strip

    if build.with? "examples"
      ENV.prepend_path "PATH", libexec
      assert_match "1 3 5 7 9 11 13 15 17 19", shell_output("#{libexec}/counts").strip
    end
  end
end
