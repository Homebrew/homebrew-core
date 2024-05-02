class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/refs/tags/5.8.5.tar.gz"
  sha256 "c3ea7ed13bea1742b3619bce2e9bfd076e600c4db6b3d9bdb4e7469027766812"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "6c97bf3b7c0584f387ed28cba374caafad154544b0453360f377849a801acc33"
    sha256 cellar: :any,                 arm64_ventura:  "e032c7f04d7afd76454471959d1030dd07e98c687e4a6c4b0a1849cfd21f0d60"
    sha256 cellar: :any,                 arm64_monterey: "fa96560920b99448a0c9977444261419c1114c23394afb08903c258748a6f9e6"
    sha256 cellar: :any,                 sonoma:         "e9420df0dd1441a33f114f27c06cff3d957aee2e1fa23eddb9ddbe91bfeaec31"
    sha256 cellar: :any,                 ventura:        "a63b5a3cba3bef3e24e8948f64c8f14b947f8237d51f86350039d7d25474177c"
    sha256 cellar: :any,                 monterey:       "bff94d603fa73e74b7d25dea597278d8d647e7aaf49e6054d5b9c9a4ce5b4ff6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a44a85e01453bfd1eae61b3d678babe31b1ae5e281f8f91db0b46f64a8e1c25"
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
