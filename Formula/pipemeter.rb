class Pipemeter < Formula
  desc "Shows speed of data moving from input to output"
  homepage "https://launchpad.net/pipemeter"
  url "https://launchpad.net/pipemeter/trunk/1.1.5/+download/pipemeter-1.1.5.tar.gz"
  sha256 "e470ac5f3e71b5eee1a925d7174a6fa8f0753f2107e067fbca3f383fab2e87d8"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "55ac3ec03d80003fd2274e7bcda397e52291c7b3749ead096dbcf6039816510c" => :big_sur
    sha256 "4946ec7fe2fa750611027a6440859fd52f9b0286f077b1b1805daf92df001e68" => :arm64_big_sur
    sha256 "ba82201ed8c010ce938f35dd987cab9ffd8d7b456cc5f4aeed8a638b88e84598" => :catalina
    sha256 "0f56a78ed6cc3e8b8eaccd21f2697fb6d810d64e2afd42deebbb251b93622c06" => :mojave
    sha256 "a599406cbf6dcdcef8029d156d00b81af91f585447e80c22b0bab27e8180cd99" => :high_sierra
  end

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"

    # Fix the man1 directory location
    inreplace "Makefile", "$(PREFIX)/man/man1", man1

    bin.mkpath
    man1.mkpath
    system "make", "install"
  end

  test do
    assert_match "3.00B", pipe_output("#{bin}/pipemeter -r 2>&1 >/dev/null", "foo", 0)
  end
end
