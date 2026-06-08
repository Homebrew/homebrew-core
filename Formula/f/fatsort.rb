class Fatsort < Formula
  desc "Sorts FAT16 and FAT32 partitions"
  homepage "https://fatsort.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/fatsort/fatsort-1.7.679.tar.xz"
  sha256 "1012f551382639d69e194eabfbe99342ede7c856b1cd6788287f9dfd4bd8d122"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/fatsort[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a364630ad4617dfd97e5af2275f62c91d1371b1452a2cdc5a9cae4c9724b058"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "145bea2b1961c492f9adc4d52df66a1c4e74465388470f320f30378418e81742"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aaacef942c280d2dee9d1e2fb1a5f1e4dc90ee452d34f1162e52d8b074fb1f54"
    sha256 cellar: :any_skip_relocation, sonoma:        "2c0bbb896f82db81e5213de928f8d02742d0e8e02506f5746260dcd229d7c8e4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "03406b3c7d87b1bfa493be10a02b0ba72898ee5d2277749ff02f39e4bcd5c59b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2e8c2792669cf23c3a31e553e513cc6de53ea82dba27bc079074da74101c3fd0"
  end

  depends_on "help2man"

  def install
    system "make", "CC=#{ENV.cc}"
    bin.install "src/fatsort"
    man1.install "man/fatsort.1"
  end

  test do
    system bin/"fatsort", "--version"
  end
end
