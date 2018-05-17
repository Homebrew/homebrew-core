class Impute2 < Formula
  desc "Genotype imputation and haplotype phasing program"
  version "2.3.2"
  homepage "https://mathgen.stats.ox.ac.uk/impute/impute_v2.html"

  url "https://mathgen.stats.ox.ac.uk/impute/impute_v2.3.2_MacOSX_Intel.tgz"
  sha256 "e91ad1edc66e6174c9dc4fdc06685df7b2d6a9ba4f86477f1a2ceef89a296953"

  def install
    bin.install "impute2"
    pkgshare.install "Example"
  end

  test do
    assert_match "IMPUTE version", shell_output("#{bin}/impute2 2>&1", 1)
  end
end
