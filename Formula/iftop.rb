# Version is "pre-release", but is what Debian, MacPorts, etc.
# package, and upstream has not had any movement in a long time.
class Iftop < Formula
  desc "Display an interface's bandwidth usage"
  homepage "http://www.ex-parrot.com/~pdw/iftop/"
  url "http://www.ex-parrot.com/pdw/iftop/download/iftop-1.0pre4.tar.gz"
  version "1.0pre4"
  sha256 "f733eeea371a7577f8fe353d86dd88d16f5b2a2e702bd96f5ffb2c197d9b4f97"

  bottle do
    cellar :any_skip_relocation
    sha256 "3a75c5edf29f6cbac19641910661423ed2f0b83f3e0de28c8417be76f4ce5c38" => :sierra
    sha256 "e7b9ed6bef435d7de8e986cedfc76779f2655bfac7ed780afb33a42e92b8d01d" => :el_capitan
    sha256 "5ac910598f86716e0dc676f0fd44af51da141ad84dfbaf5535a31f11ab91ffd7" => :yosemite
    sha256 "9563857745dca2db9f91388d3f0d0fae4b6cdc2fc6ff84ffce14325c0cafee0f" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    iftop requires root privileges so you will need to run `sudo iftop`.
    You should be certain that you trust any software you grant root privileges.
    EOS
  end

  test do
    assert_match "interface:", pipe_output("#{sbin}/iftop -t -s 1 2>&1")
  end
end
