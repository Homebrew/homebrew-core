class Pspg < Formula
  desc "Unix pager optimized for psql"
  homepage "https://github.com/okbob/pspg"
  url "https://github.com/okbob/pspg/archive/5.0.2.tar.gz"
  sha256 "c5bf3d7d2721c8afc3c8a9f70e26039572e48d29598c54c586ae5285493ffd8f"
  license "BSD-2-Clause"
  head "https://github.com/okbob/pspg.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "a5eacb15aee483a470d8e28b7f87f1c76616c81b8af05ce257226c5aa52caa7e"
    sha256 cellar: :any, big_sur:       "02c066b312968d7d85caa7525a28cde672b779b9d4db891c2c0c8436ae5a64be"
    sha256 cellar: :any, catalina:      "304b294a53b0a8a2777cbac7b93822ea66e1586120f8b157e420a80436dd21cb"
    sha256 cellar: :any, mojave:        "6bbc6b2bf9f57f81de237bf3d03cdd3f273cc4eb93b17b39b7d792f8116ce570"
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
