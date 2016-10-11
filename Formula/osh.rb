class Osh < Formula
  desc "Two ports of /bin/sh from V6 UNIX (circa 1975)"
  homepage "http://v6shell.org"
  url "http://v6shell.org/src/osh-4.2.1.tar.gz"
  sha256 "2e2855c58b88d96146accbdc60f39a5745dea571b620b5f38ebf3e43d9b0ca74"
  version_scheme 1
  head "https://github.com/JNeitzel/v6shell.git"

  bottle do
    sha256 "2d9100016e9bb2bf46e6994aa67e5261774ff81511d469f767dec05704872f77" => :sierra
    sha256 "e371b522d0b2f148107c8f953bab3922cee37fb0bdd02bf6e8a19ee00b403686" => :el_capitan
    sha256 "6e27a22cef6d23446e030e8a56d5da060a0993f228b7d311a51c7871570ed8df" => :yosemite
    sha256 "a6e827d127e48ceeecaadc3bc2efb5775ea57d470f1a7100dd2140341e479612" => :mavericks
  end

  option "with-examples", "Build with shell examples"

  resource "examples" do
    url "http://v6shell.org/v6scripts/v6scripts-20160128.tar.gz"
    sha256 "c23251137de67b042067b68f71cd85c3993c566831952af305f1fde93edcaf4d"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}", "SYSCONFDIR=#{etc}"

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
