class CrystalIcr < Formula
  desc "Interactive console for Crystal programming language"
  homepage "https://github.com/crystal-community/icr"
  url "https://github.com/crystal-community/icr/archive/v0.2.14.tar.gz"
  sha256 "0f8cb18d04cc1e0247586d66fad904d56c29658edfb04b0091c464864f2cdbdf"
  revision 1

  bottle do
    sha256 "ada603e8c7a2b417c172f602f24b15fc4641de3e3fcc3f9e919a4c3f2dd5bcb9" => :sierra
    sha256 "bcb054f7e6d87c022d8a60174d925cdd36406d767caff7539a72297c93dfe356" => :el_capitan
    sha256 "e9381659bde2c9eb2a938e002a7293c318a71103282b9852257f4814df897092" => :yosemite
  end

  depends_on "crystal-lang"
  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "icr version #{version}", shell_output("#{bin}/icr -v")
  end
end
