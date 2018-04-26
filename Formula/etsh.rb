class Etsh < Formula
  desc "Two ports of /bin/sh from V6 UNIX (circa 1975)"
  homepage "https://etsh.io/"
  url "https://etsh.io/src/etsh-5.1.5.tar.gz"
  sha256 "656e856d64d61e5b439ede6129279ec6c71a7fdda1f93303b338c93064c38811"
  version_scheme 1
  head "https://github.com/JNeitzel/v6shell.git", :branch => "current"

  bottle do
    sha256 "09d3b16b0777a87d607d161398df0076233d3a93646315640795575203380fee" => :high_sierra
    sha256 "ebefdedf62b622ddc1a2fb73bb44160b5cfcd540a0e380619a46422b34ff866e" => :sierra
    sha256 "cd8b644dfbd5bd53f268319fccc70c68b67880f05956644e34a67491f566510d" => :el_capitan
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
