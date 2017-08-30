class Oniguruma < Formula
  desc "Regular expressions library"
  homepage "https://github.com/kkos/oniguruma/"
  url "https://github.com/kkos/oniguruma/releases/download/v6.6.1/onig-6.6.1.tar.gz"
  sha256 "8f9731f9e48666236a1678e2b4ead69be682eefba3983a714b6b57cf5ee14372"

  bottle do
    cellar :any
    sha256 "18c26814d5a93ed6714396c7ebe95b8e551f9aa555084756ea607d6776655d3f" => :sierra
    sha256 "9166ee264bd95a00b163e00ba39b45fcaa6fe8b97fd414f51655d0006c06fdc1" => :el_capitan
    sha256 "3159e8d09af86fcc660fc9629d89882c3d81a4d33a3c7f1258988c6890153269" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{prefix}/, shell_output("#{bin}/onig-config --prefix")
  end
end
