class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/refs/tags/5.8.14.tar.gz"
  sha256 "9ff44945fdf08b99468808ff67c903f62205583743b6b45921dc6b366aa5e243"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "3bd320dc103c7cc54f32a50a8d358c5dbaf71202b79f8e8ae3bd91fdeb3731bd"
    sha256 cellar: :any,                 arm64_sequoia: "6d3cd071149d70c9196df3b9f25eeb5c200d41085d2392d4f772ec7a7999221c"
    sha256 cellar: :any,                 arm64_sonoma:  "b56421cf9701222a3c0a2d88652366aab074560a4e39321ba0cf82f01343a4a7"
    sha256 cellar: :any,                 sonoma:        "327205344bdb1b698cd384b78e36117937ed9cc4933e354d2de12dce025390a6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f587c97a65ace4875682b9e448f447bc137998abc30437e78c20d3cc914d6628"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ceeb51c20f981031a75291774e8956c408dace40055ef216a289edc8518606b3"
  end

  depends_on "pkgconf" => :build
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
