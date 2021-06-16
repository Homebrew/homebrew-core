class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.0.4.tar.gz"
  sha256 "e7c95a717cdba45e14961740fecd4c2824a4d78aef5629c3d197bc3264e7520c"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "b191b3e64afb9c788592c7d75781981e1e2c0c37d06ee4a58a7e2199598078a4"
    sha256 cellar: :any, big_sur:       "4f4ec2ec8b3aa8185fb73e9462b1c58a68967a073bd36cf35da448b4eb05c71e"
    sha256 cellar: :any, catalina:      "0c9c96ace196cfb67735e353bb01c9954e5da0b8d0578acef4d1e208b3c19736"
    sha256 cellar: :any, mojave:        "e80db616230ed0b6f8490694eece539a205eec3e07b412d18e3c4a0bf5c3ee30"
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
