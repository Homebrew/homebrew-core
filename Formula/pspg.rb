class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.5.6.tar.gz"
  sha256 "220417b9b1adb9e512ee66c44f655c179cfb66ec53fc7f252e3e1c75ac77c884"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "74383fe2795439bd9d1f18115d1bcb0f0dd208dc5deff3dd0195101fe9ff2858"
    sha256 cellar: :any,                 arm64_big_sur:  "db6724eabb70a00907847b3d5759515d143ce03d4e7a381eebf62fbe8c54b85f"
    sha256 cellar: :any,                 monterey:       "6079239547383513059a886df97ba046532c41fc459a72f216c6221234c848c8"
    sha256 cellar: :any,                 big_sur:        "6745a9487dade7015293e24035777f9e57375d255eed0815bfa54c10bf9dfaf9"
    sha256 cellar: :any,                 catalina:       "a48b65239ed467c1e2df20375a84c59db9536ed7e53e3de1881b6acbce73c528"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65cc618a0b63acaf300f26a8af43805a5571fa274737d9e0461e4827f10c89b6"
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
