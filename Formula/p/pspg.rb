class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/refs/tags/5.8.2.tar.gz"
  sha256 "ab9b56c68b50623a9d6ad95232cd7de9069b8374accad27298eff7dbf141c81a"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ef2bc0ffad7bb57b4220fcf8ddb9226d21ac5fc648adda3bfa04b22af6dfb92f"
    sha256 cellar: :any,                 arm64_ventura:  "7c4dc14773eb6506e4b788a23d101f28ef47fe428b14cb1a7b8411342ddfdd5c"
    sha256 cellar: :any,                 arm64_monterey: "ba00565370dd4de9afe386610cfbc3ed6731bc800a8f98e31c4c960811d08b4e"
    sha256 cellar: :any,                 sonoma:         "b4dd92fed169cbf6f981eb59f2269344cb13fedec7984a2ea13339ae5ef69af4"
    sha256 cellar: :any,                 ventura:        "49a82e9d5af29f66a4c32dc0d51d950b8ee57b0d5c58126be12131c79e552882"
    sha256 cellar: :any,                 monterey:       "861925772db8db223d1d4488c3cfdbf29a1821342ee7de86cd87e4aa49879657"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b8490c60ea454502f10057bbd00aa32a1a380e9bf85afd732fec8e31abfefff"
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
