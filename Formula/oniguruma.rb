class Oniguruma < Formula
  desc "Regular expressions library"
  homepage "https://github.com/kkos/oniguruma/"
  url "https://github.com/kkos/oniguruma/releases/download/v6.0.0/onig-6.0.0.tar.gz"
  sha256 "0cd75738a938faff4a48c403fb171e128eb9bbd396621237716dbe98c3ecd1af"

  bottle do
    cellar :any
    sha256 "48b9a51758acc36c5217cb696910c5ffa344740955f822352346cc136e9d476e" => :el_capitan
    sha256 "3d14f28ef7d925a56f582946d75333fbe8193843886c9dd2be198f0304ee0c8b" => :yosemite
    sha256 "7dc18d75d30b020bcdca7105552277a52e78dbd90e9d963bb3812706a542179c" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{prefix}/, shell_output("#{bin}/onig-config --prefix")
  end
end
