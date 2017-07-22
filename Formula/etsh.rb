class Etsh < Formula
  desc "Two ports of /bin/sh from V6 UNIX (circa 1975)"
  homepage "https://v6shell.org/"
  url "https://v6shell.org/src/etsh-4.5.1.tar.gz"
  sha256 "b9d65695789470f6cc5a4e341d85d39c1e48227909c429e96286b3cbc1eafe39"
  version_scheme 1
  head "https://github.com/JNeitzel/v6shell.git", :branch => "current"

  bottle do
    sha256 "80f892b8e239b8ae41795df0649db01185f9d6523f2f18e71802319f30e80baa" => :sierra
    sha256 "48bf611a9f34ece3b73f2a86672248f0667677e5c3ee225c6b50a472b97d629b" => :el_capitan
    sha256 "198fcf52a9c7d3e977744ff77c7eb0b01d9ede5b0539f2deca2a70c1ec2f84d0" => :yosemite
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
