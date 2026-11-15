class PariNflistdata < Formula
  desc "Data files for nflist() in PARI/GP"
  homepage "https://pari.math.u-bordeaux.fr/packages.html"
  # url "https://pari.math.u-bordeaux.fr/pub/pari/packages/nflistdata.tgz"
  url "http://deb.debian.org/debian/pool/main/p/pari-nflistdata/pari-nflistdata_0.20220729.orig.tar.gz"
  version "20220729"
  sha256 "2c19a3e02afd3bba2af3071a7faa80924a75b00bb9713286c886b7fb460944bc"
  license "GPL-2.0-or-later"

  no_autobump! because: :incompatible_version_format

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "4498f10e0cad3f1a03b38a31d0e50744c586b0dcd0a62902a97f32d7b663d710"
  end

  # Homepage and source URLs are inaccessible
  deprecate! date: "2026-10-22", because: :repo_removed
  disable! date: "2026-10-22", because: :repo_removed

  depends_on "pari"

  def install
    Dir.glob("nflistdata/*/**/*").each do |path|
      Utils::Gzip.compress(path) unless File.directory?(path)
    end

    (share/"pari/nflistdata").install Dir["nflistdata/*/"]
    doc.install "nflistdata/README"
  end

  test do
    expected_output = "[x^5 - x^4 + 2*x^2 - 2*x + 2, " \
                      "x^5 - x^4 + x^3 + 2*x^2 + x - 1, " \
                      "x^5 - 2*x^3 - 2*x^2 + 3*x + 2, " \
                      "x^5 - 2*x^4 - x^3 + 3*x^2 - x + 2, " \
                      "x^5 - 2*x^4 + 6*x^3 - 8*x^2 + 10*x - 8, " \
                      "x^5 - x^4 + 3*x^3 - 4*x^2 + 5*x - 1, " \
                      "x^5 - 2*x^3 - 4*x^2 - 6*x - 4, " \
                      "x^5 - 2*x^4 + x^2 + 4*x - 5, " \
                      "x^5 - x^4 + 3*x^3 - 3*x^2 + 5*x - 1, " \
                      "x^5 - 2*x^4 + x^3 - 5*x^2 + x - 2]"
    output = pipe_output("#{formula_opt_bin("pari")}/gp -q", "nflist(\"A5\")").chomp
    assert_equal expected_output, output
  end
end
