class Bracken < Formula
  include Language::Python::Shebang

  desc "Bayesian estimation of species abundance from Kraken output"
  homepage "https://ccb.jhu.edu/software/bracken/"
  url "https://github.com/jenniferlu717/Bracken/archive/refs/tags/v3.1.tar.gz"
  sha256 "c0a35331a8aac1e0dbb14c2a92c4de6f89f0aac540101c05c2eec54032107560"
  license "GPL-3.0-or-later"
  head "https://github.com/jenniferlu717/Bracken.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "5ae5954dd0e858cefc0f1820c818b9b800a143de367b02826e9fce331b27d770"
    sha256 cellar: :any, arm64_sequoia: "e03480ebf6f9900631b05da3586cb6b477c78a6fae77895200212fa986b970ab"
    sha256 cellar: :any, arm64_sonoma:  "36637a9ac82a43ca8fd0cfbd1f9e3f925641ca2da1f2df4de7d34e552af80346"
    sha256 cellar: :any, sonoma:        "0e4b2578ec0a82fa034bfbf36020ad6528385f5fef2a9808fdc52971206f12b6"
    sha256 cellar: :any, arm64_linux:   "3a4ac369c1faf0e3b4b7fcb6332b47b091f588abbbce5cf90a1289def5a11c5e"
    sha256 cellar: :any, x86_64_linux:  "d54476bbc6a1525ba9e65b23169b508efe1487476ee69418a1b024d2c5448b8b"
  end

  depends_on "kraken2"

  uses_from_macos "python"

  on_macos do
    depends_on "libomp"
  end

  def install
    system "make", "-C", "src"

    inreplace ["bracken", "bracken-build"] do |s|
      s.gsub! "$DIR/src/", "#{libexec}/"
      s.gsub! "python #{libexec}/", "#{libexec}/"
    end

    libexec.install "src/est_abundance.py", "src/generate_kmer_distribution.py", "src/kmer2read_distr"
    rewrite_shebang detected_python_shebang(use_python_from_path: true),
      libexec/"est_abundance.py",
      libexec/"generate_kmer_distribution.py"
    bin.install "bracken", "bracken-build"
  end

  test do
    # Exercise Bracken's abundance re-estimation on a minimal Kraken2 report
    # plus a matching kmer distribution, checking the estimated species row.
    report = [
      "50.00\t100\t100\tU\t0\tunclassified",
      "50.00\t100\t0\tR\t1\troot",
      "100.00\t100\t0\tD\t2\t  Bacteria",
      "100.00\t100\t0\tP\t1224\t    Proteobacteria",
      "100.00\t100\t0\tG\t561\t      Escherichia",
      "100.00\t100\t100\tS\t562\t        Escherichia coli",
    ].join("\n")
    (testpath/"report.txt").write "#{report}\n"
    database = testpath/"database"
    database.mkpath
    (database/"database100mers.kmer_distrib").write "562\t562:1000:1000\n"

    system bin/"bracken", "-d", database, "-i", "report.txt", "-o", "abundance.txt",
                          "-r", "100", "-l", "S", "-t", "0"
    assert_match "Escherichia coli\t562\tS\t100", (testpath/"abundance.txt").read
  end
end
