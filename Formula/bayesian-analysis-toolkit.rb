class BayesianAnalysisToolkit < Formula
  desc "Bayesian analysis toolkit"
  homepage "https://bat.mpp.mpg.de/"
  url "https://github.com/bat/bat/releases/download/v1.0.0/BAT-1.0.0.tar.gz"
  sha256 "620e8069d85f18f8504137823621cbb578fa5b159e3074f0f2379ac295dd1482"

  depends_on "cuba"
  depends_on "root"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-cuba"
    system "make", "install"
    (pkgshare/"examples").install "examples/basic"
    (pkgshare/"examples").install "examples/advanced"
  end

  test do
    system "#{pkgshare}/examples/basic/binomial/runEfficiency"
  end
end
