class Etsh < Formula
  desc "Two ports of /bin/sh from V6 UNIX (circa 1975)"
  homepage "https://v6shell.org/"
  url "https://v6shell.org/src/etsh-5.0.0.tar.gz"
  sha256 "1b8ac975c384a4d470425b29c5c858a48c85360d3d193b25394c5ccf87b4d51f"
  version_scheme 1
  head "https://github.com/JNeitzel/v6shell.git", :branch => "current"

  bottle do
    sha256 "45657144d19e33191f30dd875c10c753ad2e311d2b3c4a7d300d2dfcb3484cf4" => :high_sierra
    sha256 "ccba4400bad5e68c70d86d43c2973848bd204f66b7123f7f86f1f76b7d3511d1" => :sierra
    sha256 "2a53e0628ba0e958d72a6bd999ee07bc11f6ba6fdf1ceb053dcdd3338eae0ea3" => :el_capitan
  end

  option "with-examples", "Build with shell examples"

  conflicts_with "teleport", :because => "both install `tsh` binaries"

  resource "examples" do
    url "https://v6shell.org/v6scripts/v6scripts-20160128.tar.gz"
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
