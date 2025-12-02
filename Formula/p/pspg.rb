class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/refs/tags/5.8.12.tar.gz"
  sha256 "9f74c236944bea79586a3a12ab9d36735bfa62a92a8d7953e8c1ff5c108277af"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7fe2a3cbd810de303eedd8f00a1924cebc6a355091ad2db3f3388bbe496a35e3"
    sha256 cellar: :any,                 arm64_sequoia: "fbe4f496a3be5e9693ed3fb8f532c4be80249f5a1d027a4596cb99b068260251"
    sha256 cellar: :any,                 arm64_sonoma:  "4f040dd530d13e63abd48b42ba1fcfce456521b6e614d29b6459affc5dfb3ef2"
    sha256 cellar: :any,                 arm64_ventura: "74f4d329d3a79d1eff8c630da561f88c38c9b4a9063cded46984e8fb708e8ab0"
    sha256 cellar: :any,                 sonoma:        "868c9354fdb876a4ae62698a16ccf3a78cc3ac1436e3c696cc97cff2371f564f"
    sha256 cellar: :any,                 ventura:       "584924c89855547aa825967a064f74069fdf4362ba763751506d2be715745d43"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74d4498d4936a5f20fc9a3d0633fb5d16c51d7f2f32d3cedbb1f44f6a6784af0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9119d05dae43df503adc6629c39fe856604f469c7f4b1ecb300b12c6ffe815b"
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
