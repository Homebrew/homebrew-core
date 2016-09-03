class Oniguruma < Formula
  desc "Regular expressions library"
  homepage "https://github.com/kkos/oniguruma/"
  url "https://github.com/kkos/oniguruma/releases/download/v6.1.1/onig-6.1.1.tar.gz"
  sha256 "b9cf2eefef5105820c97f94a2ccd12ed8aa274a576ccdaaed3c632a2aa0d0f04"

  bottle do
    cellar :any
    sha256 "94fc0d6205348bb2462b3786f917547068a86c8ee8d48462297e2a666d69ad7e" => :el_capitan
    sha256 "775764a099ba44167efdb9ad76e6d082c772100a3c92e060ec6dd0102ceb2e04" => :yosemite
    sha256 "3714187af50dfaa7106796167bb604a73f84a69e9daef725a4df1f2b06fec992" => :mavericks
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /#{prefix}/, shell_output("#{bin}/onig-config --prefix")
  end
end
