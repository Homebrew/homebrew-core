class Oniguruma < Formula
  desc "Regular expressions library"
  homepage "https://github.com/kkos/oniguruma/"
  url "https://github.com/kkos/oniguruma/releases/download/v6.2.0/onig-6.2.0.tar.gz"
  sha256 "6561637f340c6cae468aa4df45c7a4d8525fad65495b0dcef72d749aa8733a4b"

  bottle do
    cellar :any
    sha256 "21472564a4d6aea249a86b99b195f1336718d1ab991ebf8b94aceacaff5bd9df" => :sierra
    sha256 "0c3555d4314f6ec308f5f947b3ad3721ff5bbfb75e7c581caeac442ade476b0e" => :el_capitan
    sha256 "11e02ff297b2c416bed77d5066cec5a74162d98f21976385d8d9da9e3269c8c3" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{prefix}/, shell_output("#{bin}/onig-config --prefix")
  end
end
