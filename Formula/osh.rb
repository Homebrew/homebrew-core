class Osh < Formula
  desc "Two ports of /bin/sh from V6 UNIX (circa 1975)"
  homepage "https://v6shell.org/"
  url "https://v6shell.org/src/osh-4.3.2.tar.gz"
  sha256 "6123b24cd87e70cbf99f26ce5dea992abedf7e4f0c6ad964853427919b47dcc7"
  version_scheme 1
  head "https://github.com/JNeitzel/v6shell.git"

  bottle do
    sha256 "964ca2eb8344d93890c32c4330fd66bb5e6d77635349de1525bc1ffb1825041c" => :sierra
    sha256 "723350de5a7d4f40eae9f67b1d3c1e1a7c911a0c5c17e77e52cbed6615e03842" => :el_capitan
    sha256 "8928ba25a0a3f5c13aa8896e728eaf239d7451ad84081e41fd4509d86969b500" => :yosemite
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
