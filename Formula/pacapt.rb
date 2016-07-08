class Pacapt < Formula
  desc "Package manager in the style or Arch's pacman"
  homepage "https://github.com/icy/pacapt"
  url "https://github.com/icy/pacapt/archive/v2.3.9.tar.gz"
  sha256 "878f971e6abb6ddca4c0b52fb962fb236901872eb1a383530fae78554494a6da"

  bottle do
    cellar :any_skip_relocation
    sha256 "c881121d58f594b795766e1724606bfbebbd639ba50a0101fa9283cccbeb6637" => :el_capitan
    sha256 "8cb44126cdb63db825bf2e9e680137aaa43c14640e5b6a962b0f210f6c969bdf" => :yosemite
    sha256 "6883ca9a05cac6f4efbd8a39cd8797c71fa8bd718d567c587078fbb01bdf2d6e" => :mavericks
  end

  def install
    bin.mkpath
    system "make", "install", "BINDIR=#{bin}", "VERSION=#{version}"
  end

  test do
    system "#{bin}/pacapt", "-Ss", "wget"
  end
end
