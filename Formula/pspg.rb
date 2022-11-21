class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.5.9.tar.gz"
  sha256 "e517baaf9fdf594d7e231c51bde66fd59f3b74753aad0b46b1f42b9d8b2e029a"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1f766afd9ca820ba987ac3e89496161f5df060540b741980dfd60dc9ec0c9f13"
    sha256 cellar: :any,                 arm64_monterey: "c54323ab59bb9bbe4671c924c1a646a68b19644e3b70882bbd487dc52941aa12"
    sha256 cellar: :any,                 arm64_big_sur:  "fae746dcb591bd247afa1b9eb14f3e157ca6131e9c69011250cb618b2fe17042"
    sha256 cellar: :any,                 ventura:        "f3dda63878c468a2eeb3af3ecbc689d713849e9c59b91100e29e7df2dd445bd7"
    sha256 cellar: :any,                 monterey:       "282dc7b0f0b6091d9e2d1c8549219111a9588a15ad5867fde89c11d31f04c591"
    sha256 cellar: :any,                 big_sur:        "73feabf78442b692961e82883b976ae900f9ec16baadbae6807fce550c54f898"
    sha256 cellar: :any,                 catalina:       "c337e4e6760e5cea96639e38c071daf4b3bd0c24890582ddbcde2c8e24853c42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5e31c7349a791d4cf2ee07ba725f1527876dd0019505a2d556562fae5ca340d6"
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
