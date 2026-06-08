class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/refs/tags/5.8.16.tar.gz"
  sha256 "3dcfb810cc6675cac6e3ea53775a6f819e0e12e0d2bde8122e3136b740f38ae5"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8dd9ef474eaf5c99b2119f4a49fbdefd42fc8cfed43d87d37cf6913fdc3707e0"
    sha256 cellar: :any,                 arm64_sequoia: "ddfc22db81961ba59d8bd6e4a3e930694f513f0e9d82822633b620df1677afe5"
    sha256 cellar: :any,                 arm64_sonoma:  "d4bc31a1f509fcf4d95d237ab38ca0ddf41135336d3b4712c686df9204001fce"
    sha256 cellar: :any,                 sonoma:        "ae834e0bd0ef320b448797dc3f5ef5c8106c08ba1834cbcc2eb5ec0af75a3a80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6afc64962efc19340ebc106abcf81994edfed6c1dd84d9e631e7c020222178ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f18b85a40c801269b01cfcef69ccac84a09e910585e67a1040b48d4191904ca5"
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
