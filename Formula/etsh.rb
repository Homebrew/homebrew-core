class Etsh < Formula
  desc "Two ports of /bin/sh from V6 UNIX (circa 1975)"
  homepage "https://v6shell.org/"
  url "https://v6shell.org/src/etsh-4.9.0.tar.gz"
  sha256 "b3908c4df09173551523d02c0b04bfb74109bd55e5edec9b80694666adff2d3d"
  version_scheme 1
  head "https://github.com/JNeitzel/v6shell.git", :branch => "current"

  bottle do
    sha256 "8f9e6f31253d7185e49b61b26576eea7ab4386496ffea501f2b01212b8874b8d" => :high_sierra
    sha256 "4362858c5dada0a74766384a7daad6b8132d98cce81644635d4c392ad90e2419" => :sierra
    sha256 "aaa1faf7005aaef66a66704a0eee67eebb98a87c7cafeddcd1fa866045c2c74d" => :el_capitan
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
