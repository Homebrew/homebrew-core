class Cppunit < Formula
  desc "Unit testing framework for C++"
  homepage "https://wiki.freedesktop.org/www/Software/cppunit/"
  url "https://dev-www.libreoffice.org/src/cppunit-1.14.0.tar.gz"
  sha256 "3d569869d27b48860210c758c4f313082103a5e58219a7669b52bfd29d674780"

  bottle do
    cellar :any
    rebuild 1
    sha256 "1f0d4bfcd8fb19cd29e1c1cf74effe73e2950ab9252b85d07bf712b5926cb041" => :sierra
    sha256 "27730fdd237f61dd3698e422edab55246d657f15fcbb73999d8b35087e3cb3c8" => :el_capitan
    sha256 "235b62030002ef0c7c84c4989ac0ca3401c96929053e0095a605660b30aa9eba" => :yosemite
    sha256 "f66998bbde3f7c3ca32f3a99c35177cd80ff8f6583ec63627d7526455a503214" => :mavericks
    sha256 "0494ee4b157acec4c86c4d26a2c1155e71e11e5dc3a897ae1888a3da4edbb21f" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match "Usage", shell_output("#{bin}/DllPlugInTester", 2)
  end
end
