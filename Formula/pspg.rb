class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.7.4.tar.gz"
  sha256 "c7bec2a4640f6255b32c698c1c6d9e3e868585137016f35a1a5bc7c25dcd67b5"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1117ec9dc1f0746fe275996351403df22cf95220e9e2433c54ef56facd7e6ddb"
    sha256 cellar: :any,                 arm64_monterey: "f786c7f72fa4f23c4518761fe7ecf13c6fe25b55e5bdb589654a733373fc3849"
    sha256 cellar: :any,                 arm64_big_sur:  "186906b716dd3d350d6239a0ba7316772eb96a624c59f9588521dc191abae77e"
    sha256 cellar: :any,                 ventura:        "d05624c1fec742006c7c520210085ab22606211c0af5c5fe491aa615cd4262cd"
    sha256 cellar: :any,                 monterey:       "1181bbc87d623d7e1ddad78f8dbf61aeda3e508f224cab77d73bc056dfde582e"
    sha256 cellar: :any,                 big_sur:        "ef5e971d39fa2e01244f35829e40a1954d5a3b4a5362b44a2f2ad3beabfbf952"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34edee7fc4bbf47a10478c3d5d261477997350afcbe7561cecf5a7728e785190"
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
