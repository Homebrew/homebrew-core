class Memtester < Formula
  desc "Utility for testing the memory subsystem"
  homepage "http://pyropus.ca/software/memtester/"
  url "http://pyropus.ca/software/memtester/old-versions/memtester-4.5.0.tar.gz"
  sha256 "8ed52b0d06d4aeb61954994146e2a5b2d20448a8f3ce3ee995120e6dbde2ae37"
  license "GPL-2.0-only"

  # Despite the name, all the versions are seemingly found on this page. If this
  # doesn't end up being true over time, we can check the homepage instead.
  livecheck do
    url "http://pyropus.ca/software/memtester/old-versions/"
    regex(/href=.*?memtester[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "3e5d78ffc5d9fee92d95d3107aa82d6519830746ebeacc7e57f29d510c84b009" => :big_sur
    sha256 "42853393d7487f7e754b8131fffd04a4dc17b3fe0aa7438c3fe3ebb459f50779" => :arm64_big_sur
    sha256 "3a076907f16eea276860af92f2ce27ac3ffa5f7ddb6b107bcd0767a4d2ae8f9e" => :catalina
    sha256 "0d0340b01dbeef9616b14cdb1b31d60f7c55280c289d6220a613fc15cbb73978" => :mojave
    sha256 "1f4076eee7326cf525af344331ffd23b6961148b16c82cf9f8ba28e0f098a881" => :high_sierra
  end

  def install
    inreplace "Makefile" do |s|
      s.change_make_var! "INSTALLPATH", prefix
      s.gsub! "man/man8", "share/man/man8"
    end
    inreplace "conf-ld", " -s", ""
    system "make", "install"
  end

  test do
    system bin/"memtester", "1", "1"
  end
end
