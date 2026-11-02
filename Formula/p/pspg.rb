class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/refs/tags/5.9.1.tar.gz"
  sha256 "d61d82a2e8c8980d52d2715bb2cc32bfb20e8a2a15ea15bdb7105a2ff5ea1ac4"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "09e68266ea986a95c024d87023451026c91f831e528e6b8a9c8490b10807b458"
    sha256 cellar: :any, arm64_tahoe:       "110bec0bf578f49195b7fdfa4e22d9cd39c109ab8d2af148096dbb73ca6bda84"
    sha256 cellar: :any, arm64_sequoia:     "b65c628460a8a5f7393c1c55e56559f1d8c549cf7bf1dd5af3ca7ebcde51330e"
    sha256 cellar: :any, arm64_linux:       "ec763de30aa6ef014c0610963bd07d294b9d4b6053ed9e99dc6be41d7c4a60d8"
    sha256 cellar: :any, x86_64_linux:      "5833088f4683898828ad19fe53511e89e0c3236d179c4c9f13a4fb9471c41cf9"
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
