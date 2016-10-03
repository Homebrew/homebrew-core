class Mlogger < Formula
  desc "Log to syslog from the command-line"
  homepage "https://github.com/nbrownus/mlogger"
  url "https://github.com/nbrownus/mlogger/archive/v1.2.0.tar.gz"
  sha256 "141bb9af13a8f0e865c8509ac810c10be4e21f14db5256ef5c7a6731b490bf32"

  bottle do
    cellar :any_skip_relocation
    sha256 "1f7392a3d16a2bf595487a4b35bf5c866fa00c0967629eef46f07cbf6e696ff4" => :sierra
    sha256 "e1f78a9ef569085efcac8c41bd2a70feda85e7fcba5eb7b46a9ee5341cf8cb2d" => :el_capitan
    sha256 "f64331a815b26047bc982340650aae806a568a10060adfc819e25d077059af2e" => :yosemite
  end

  def install
    system "make"
    bin.install "mlogger"
  end

  test do
    system "mlogger", "-i", "-d", "test"
  end
end
