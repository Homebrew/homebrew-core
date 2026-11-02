class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/refs/tags/5.9.1.tar.gz"
  sha256 "d61d82a2e8c8980d52d2715bb2cc32bfb20e8a2a15ea15bdb7105a2ff5ea1ac4"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e3b78d9215193684da5744b0912e844bb8ac2f6c9b136b7d2d9b93cb10d2ab2a"
    sha256 cellar: :any, arm64_tahoe:       "857aa3361692d8c66693515bde6f6ab273e8234aece3030d447ba5f3ed0d6671"
    sha256 cellar: :any, arm64_sequoia:     "14e434ab67ad394f19602109a0c18830f3b4db3d54f9f472d63388d4d0792914"
    sha256 cellar: :any, arm64_linux:       "8ba01d872d515b7a493f5c42bfdee039831b03b63e0115440bbba55386c7fcaf"
    sha256 cellar: :any, x86_64_linux:      "ea067c77953b124ff4afa2b235d405c03d10e4d534f5063db7deaff26990aec9"
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
