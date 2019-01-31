class Enonic < Formula
  desc "Enonic XP command line interface."
  homepage "http://enonic.com/"
  url "http://repo.enonic.com/public/com/enonic/cli/enonic/0.3/enonic_0.3_Mac_64-bit.tar.gz"
  version "0.3"
  sha256 "54611984883d9c6c04124b41a0d29d2c226f06808c17722eaf6aa28187ea1ca5"

  def install
    bin.install "enonic"
  end
end
