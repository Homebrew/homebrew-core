class Dateutils < Formula
  desc "Tools to manipulate dates with a focus on financial data"
  homepage "https://www.fresse.org/dateutils/"
  url "https://github.com/hroptatyr/dateutils/releases/download/v0.4.10/dateutils-0.4.10.tar.xz"
  sha256 "3c508e2889b9d5aecab7d59d7325a70089593111a1230a496dab0f5ad677cdec"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_sonoma:   "3cbfaa460e673d3538663e693461dd4556a668a2881c7b07c64b62c3c163e2da"
    sha256 arm64_ventura:  "357e119eca0f8b05aa9e15ca847fb65e8d62739f44c8a1a671fea692955e89a7"
    sha256 arm64_monterey: "1f9136ae36f078bc62bb4a156789182c8be9db5263ff5c8181178bf0dddafda1"
    sha256 arm64_big_sur:  "af290ad842df546fa9b2280741bbaebb8f2bd1b0c6480311950179a1216acb9e"
    sha256 sonoma:         "9aa3ee9816f97645b3d4b639b03ad7ca619f8532f385af8180ad9dcaa52202b1"
    sha256 ventura:        "708045bf22f4d361013ab178669816efa4bf7ee8f572f712d85505b3e1cbff42"
    sha256 monterey:       "81a67f3ef6fc31ccfc373abba87c97a123897a5c95af0d1d09775914acfbc704"
    sha256 big_sur:        "d64298bb58e3f4cbb9515c47d2da2afd28ef4723e048e74bcd82b100852e5933"
    sha256 catalina:       "d466942058dc6d8d0d6bbdbd3d8e923b025b8f64a845f558263985cc40bd5b4d"
    sha256 x86_64_linux:   "dd75e3c37e59d4a89d04f0e8b5383b2e938c2c2d8dbe4d32bc60de434cf9e5e2"
  end

  head do
    url "https://github.com/hroptatyr/dateutils.git", branch: "master"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "-iv" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/dconv 2012-03-04 -f \"%Y-%m-%c-%w\"").strip
    assert_equal "2012-03-01-07", output
  end
end
