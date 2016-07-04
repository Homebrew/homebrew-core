class Osh < Formula
  desc "Two ports of /bin/sh from V6 UNIX (circa 1975)"
  homepage "http://v6shell.org"
  url "http://v6shell.org/src/osh-4.2.1.tar.gz"
  # TODO: fix this when epochs exist
  version "20160515"
  sha256 "2e2855c58b88d96146accbdc60f39a5745dea571b620b5f38ebf3e43d9b0ca74"
  head "https://github.com/JNeitzel/v6shell.git"

  bottle do
    sha256 "cedd57af18833fdca6996438d708c5b6e90a2a332c5e3e3e0795d40842e090c7" => :el_capitan
    sha256 "b905743bf8cdd83730ef394e45b5f6d98f6ec0af06559589012a307fde957a06" => :yosemite
    sha256 "0f0d9e240615dabed38ecaac5ec85d5eab948a29afb70f5a845e802cd8bc6392" => :mavericks
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
    assert_match /Homebrew!/, shell_output("#{bin}/osh -c 'echo Homebrew!'").strip

    if build.with? "examples"
      ENV.prepend_path "PATH", libexec
      assert_match /1 3 5 7 9 11 13 15 17 19/, shell_output("#{libexec}/counts").strip
    end
  end
end
