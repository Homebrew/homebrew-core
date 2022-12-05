class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.6.4.tar.gz"
  sha256 "195cbafdc9ed5b7eb1724b19cd1f88a711d62c979e27f5418996c7e14fe370f5"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "2ed8b4379b6b304be7c0c443eb246022d0df9eed3ae07a4c97d5a52b79a2e5d9"
    sha256 cellar: :any,                 arm64_monterey: "7281d87697ca37795ce7598534b4e1f255aeca758ffdd67d26fb16197a893d73"
    sha256 cellar: :any,                 arm64_big_sur:  "c1dce3fe1225eaa49ac592b439286003beb67df3a28fa8ef72a37a6da913be3b"
    sha256 cellar: :any,                 ventura:        "2d00dc790b2596d3193571ee48067102b2b36817d11a8b869c7de4667fe7603b"
    sha256 cellar: :any,                 monterey:       "24bac011ba1e55fadafd048d7a04063b3f0e4683512c1ad6db1386a70b69184a"
    sha256 cellar: :any,                 big_sur:        "85aa2d8ff02d1ff8289b995e739c4fac0d99f7942987930ff870819ce76df61b"
    sha256 cellar: :any,                 catalina:       "2509001054ebc4d211f8964dc4ef8e374fd6155ed281fee9b75cb55ce9469141"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95cdc06d90f2b9340875a5422373989b2cd9f4acb5033397f9dabd97b11f82e1"
  end

  depends_on "libpq"
  depends_on "ncurses"
  depends_on "readline"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Add the following line to your psql profile (e.g. ~/.psqlrc)
        \\setenv PAGER pspg
        \\pset border 2
        \\pset linestyle unicode
    EOS
  end

  test do
    assert_match "pspg-#{version}", shell_output("#{bin}/pspg --version")
  end
end
