class Etsh < Formula
  desc "Two ports of /bin/sh from V6 UNIX (circa 1975)"
  homepage "https://etsh.io/"
  url "https://etsh.io/src/etsh-5.0.2.tar.gz"
  sha256 "00e6e1453aad73aa632fb68ef7f249aa88eed434f8702c48ea25b2569da35ce5"
  version_scheme 1
  head "https://github.com/JNeitzel/v6shell.git", :branch => "current"

  bottle do
    sha256 "43bbd7ecf7d41e7cc01558ee783d6c1bbee7b635dd055bf095d88ba481a8b476" => :high_sierra
    sha256 "a5761fbff0c1ed0d9378709077b50e4f7c0eec5d40dc4f980114373d50d0d14b" => :sierra
    sha256 "0686a9c636ac06102d55037bdfc3563370d5b27310c5cc22da5b1b3607357a8e" => :el_capitan
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
