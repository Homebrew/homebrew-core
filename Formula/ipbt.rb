class Ipbt < Formula
  desc "Program for recording a UNIX terminal session"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/"
  url "https://www.chiark.greenend.org.uk/~sgtatham/ipbt/ipbt-20210215.5a9cb02.tar.gz"
  version "20210215"
  sha256 "0aeafaacbccb89d2aaf044d6c6582c71cb66f607847854f2df514a21f6a5cb70"
  license "MIT"

  livecheck do
    url :homepage
    regex(/href=.*?ipbt[._-]v?(\d+)(?:\.[\da-z]+)?\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "93862f6474250d069f0bac1b463cbbe1228bf0b713c4234e683cff991f8d8dba"
    sha256 cellar: :any_skip_relocation, big_sur:       "ac90fea5805663d24f9a6a712064ab0d3d543322523585e1b382521ed156a979"
    sha256 cellar: :any_skip_relocation, catalina:      "a702173664a98d4d1f42a6ef4599f733916a64cea7e4dc995b83e73739ac455f"
    sha256 cellar: :any_skip_relocation, mojave:        "636394fcd3103d17aa176ef176bc8e6a2bf8f01517ff0bdb1ed8aa1faf9c6358"
  end

  uses_from_macos "ncurses"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system "#{bin}/ipbt"
  end
end
