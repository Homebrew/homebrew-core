class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/4.0.0.tar.gz"
  sha256 "e2e96a8ec7ea2ac97ca4248b3f789e40910933ac9fd8bc4d5cd54f3b337fba01"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git"

  bottle do
    cellar :any
    sha256 "ed2c1ad1c692387f910a6f7e9a528d55147b6a0cd02ecda503bc0c216af96cba" => :big_sur
    sha256 "15e280276062001a73dcc2ef860a9f755f67c123e9b43720d029e0f500ed4a1f" => :arm64_big_sur
    sha256 "21e2efbe6cfaabe7e6b14f1457a61ffd2749b641ed3d3d252f849537ec4cae10" => :catalina
    sha256 "cb76982d14b5490e86d2664b02f127eb7848ed792a2eb61624fde9467411f6fd" => :mojave
    sha256 "51dba789c8fb09d7317ef41383405187188ac1b68099df0a9358bc75fbf2df38" => :high_sierra
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
